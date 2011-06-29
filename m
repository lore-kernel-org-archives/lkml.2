Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1F2IeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab1F2IeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:34:06 -0400
Message-ID: <4E0AE36B.9010500@redhat.com>
Date: Wed, 29 Jun 2011 10:33:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: virtio scsi host draft specification, v3
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <4DF71E28.6070009@suse.de>
In-Reply-To: <4DF71E28.6070009@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 10:39 AM, Hannes Reinecke wrote:
> If, however, we decide to expose some details about the backend, we
> could be using the values from the backend directly.
> EG we could be forwarding the SCSI target port identifier here
> (if backed by real hardware) or creating our own SAS-type
> identifier when backed by qemu block. Then we could just query
> the backend via a new command on the controlq
> (eg 'list target ports') and wouldn't have to worry about any protocol
> specific details here.

Besides the controlq command, which I can certainly add, this is 
actually quite similar to what I had in mind (though my plan likely 
would not have worked because I was expecting hierarchical LUNs used 
uniformly).  So, "list target ports" would return a set of LUN values to 
which you can send REPORT LUNS, or something like that?  I suppose that 
if you're using real hardware as the backing storage the in-kernel 
target can provide that.

For the QEMU backend I'd keep hierarchical LUNs, though of course one 
could add a FC or SAS bus to QEMU, each implementing its own identifier 
scheme.

If I understand it correctly, it should remain possible to use a single 
host for both pass-through and emulated targets.

Would you draft the command structure, so I can incorporate it into the 
spec?

> Of course, when doing so we would be lose the ability to freely remap
> LUNs. But then remapping LUNs doesn't gain you much imho.
> Plus you could always use qemu block backend here if you want
> to hide the details.

And you could always use the QEMU block backend with scsi-generic if you 
want to remap LUNs, instead of true passthrough via the kernel target.

Paolo
