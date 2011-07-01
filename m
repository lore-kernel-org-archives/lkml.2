Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab1GAGln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 02:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab1GAGll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 02:41:41 -0400
Message-ID: <4E0D6C08.1040201@redhat.com>
Date: Fri, 01 Jul 2011 08:41:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: virtio scsi host draft specification, v3
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>	<4DF71E28.6070009@suse.de>	<4E0AE36B.9010500@redhat.com> <BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com>
In-Reply-To: <BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 11:39 AM, Stefan Hajnoczi wrote:
> > >  Of course, when doing so we would be lose the ability to freely remap
> > >  LUNs. But then remapping LUNs doesn't gain you much imho.
> > >  Plus you could always use qemu block backend here if you want
> > >  to hide the details.
> >
> >  And you could always use the QEMU block backend with scsi-generic if you
> >  want to remap LUNs, instead of true passthrough via the kernel target.
>
> IIUC the in-kernel target always does remapping.  It passes through
> individual LUNs rather than entire targets and you pick LU Numbers to
> map to the backing storage (which may or may not be a SCSI
> pass-through device).  Nicholas Bellinger can confirm whether this is
> correct.

But then I don't understand.  If you pick LU numbers both with the 
in-kernel target and with QEMU, you do not need to use e.g. WWPNs with 
fiber channel, because we are not passing through the details of the 
transport protocol (one day we might have virtio-fc, but more likely 
not).  So the LUNs you use might as well be represented by hierarchical 
LUNs.

Using NPIV with KVM would be done by mapping the same virtual N_Port ID 
in the host(s) to the same LU number in the guest.  You might already do 
this now with virtio-blk, in fact.

Put in another way: the virtio-scsi device is itself a SCSI target, so 
yes, there is a single target port identifier in virtio-scsi.  But this 
SCSI target just passes requests down to multiple real targets, and so 
will let you do ALUA and all that.

Of course if I am dead wrong please correct me.

Paolo
