Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1JZFWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:22:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1JZFWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:22:16 -0400
Message-ID: <4EA79A0E.8030604@suse.de>
Date: Wed, 26 Oct 2011 07:26:38 +0200
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux Products GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: ya su <suya94335@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: about NPIV with qemu-kvm.
References: <CA+tHM2Hw4jzTNmNtD3ttVpyCFCHnFB9USWK5XsUK6vqGJVmGRg@mail.gmail.com>
In-Reply-To: <CA+tHM2Hw4jzTNmNtD3ttVpyCFCHnFB9USWK5XsUK6vqGJVmGRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 06:40 AM, ya su wrote:
> hi, hannes:
> 
>     I want to use NPIV with qemu-kvm, I issued the following command:
> 
>     echo '1111222233334444:5555666677778888' >
> /sys/class/fc_host/host0/vport_create
> 
>     and it will produce a new host6 and one vport succesfully, but it
> does not create any virtual hba pci device. so I don't know how to
> assign the virtual host to qemu-kvm.
> 
Well, you can't. There is no mechanism for. When using NPIV you need
to pass in the individual LUNs via eg virtio-blk.

>     from your this mail, does array will first need to assign a lun to
> this vport? and through this new created disk, like device /dev/sdf,
> then I add qemu-kvm with -drive file=/dev/sdf,if=virtio... arguments?
> 
Yes. That's what you need to do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke              zSeries & Storage
hare@suse.de                  +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
