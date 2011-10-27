Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1J0Mx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:53:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57831 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1J0Mxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <4EA79A0E.8030604@suse.de>
References: <CA+tHM2Hw4jzTNmNtD3ttVpyCFCHnFB9USWK5XsUK6vqGJVmGRg@mail.gmail.com>
	<4EA79A0E.8030604@suse.de>
Date: Thu, 27 Oct 2011 20:53:53 +0800
Message-ID: <CA+tHM2FfeqiUK38r-kKZ4eqr1nTb_F65uVhjB2v2cC4L_pGpNQ@mail.gmail.com>
Subject: Re: about NPIV with qemu-kvm.
From: ya su <suya94335@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, hannes

      I really appreciate your clarify of my daze.

      as to improve vm's storage io perfomance as nearly hardware's,
it seems the only way is something like sr-iov by hba card.  NPIV can
not achieve this goal.

      I remember that LSI released some kind SAS controller(IR 2008?)
which support sr-iov , but there is not any document which describes
the steps to config. I wonder if your have any clues to help? thanks.

Regards.

Suya.

2011/10/26, Hannes Reinecke <hare@suse.de>:
> On 10/26/2011 06:40 AM, ya su wrote:
>> hi, hannes:
>>
>>     I want to use NPIV with qemu-kvm, I issued the following command:
>>
>>     echo '1111222233334444:5555666677778888' >
>> /sys/class/fc_host/host0/vport_create
>>
>>     and it will produce a new host6 and one vport succesfully, but it
>> does not create any virtual hba pci device. so I don't know how to
>> assign the virtual host to qemu-kvm.
>>
> Well, you can't. There is no mechanism for. When using NPIV you need
> to pass in the individual LUNs via eg virtio-blk.
>
>>     from your this mail, does array will first need to assign a lun to
>> this vport? and through this new created disk, like device /dev/sdf,
>> then I add qemu-kvm with -drive file=/dev/sdf,if=virtio... arguments?
>>
> Yes. That's what you need to do.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke              zSeries & Storage
> hare@suse.de                  +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: Markus Rex, HRB 16746 (AG Nürnberg)
>
