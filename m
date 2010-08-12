Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab0HLBFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:05:40 -0400
Received: from clueserver.org ([65.102.45.174]:60331 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0HLBFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:05:39 -0400
X-Greylist: delayed 2214 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 21:05:39 EDT
Date: Wed, 11 Aug 2010 17:27:29 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@mail.fnordora.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Question on siig sata 3 controller
In-Reply-To: <20100810134817.GA25874@bitwizard.nl>
Message-ID: <alpine.LRH.2.00.1008111726210.28286@mail.fnordora.org>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2> <4C10A81F.50801@garzik.org> <54318.10.6.6.23.1276222123.squirrel@10.6.6.2> <20100615065714.GA9034@bitwizard.nl> <20100615110748.4303a106@lxorguk.ukuu.org.uk> <20100615145342.GC26989@bitwizard.nl>
 <20100615160137.62c92494@lxorguk.ukuu.org.uk> <1276622732.6843.2.camel@zowie.clueserver.org> <20100810134817.GA25874@bitwizard.nl>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Rogier Wolff wrote:

> On Tue, Jun 15, 2010 at 10:25:32AM -0700, Alan wrote:
>> On Tue, 2010-06-15 at 16:01 +0100, Alan Cox wrote:
>>>> Is one of these modules the driver for this controller? I think it's
>>>> AHCI: lshw says it uses ports cc00 ... and a bunch of others, and
>>>> those ports are claimed by ahci according to /proc/ioports. Ah! I need
>>>> better eyes. lshw already mentions that it's ahci...
>>>
>>> AHCI will be driving it.
>>
>> I have seen this problem with the 2.6.33 kernel in Fedora 13. The
>> problem goes away in 2.6.35-rc3. (Though networking is fubared for me on
>> that kernel, so I have not migrated to it.)
>>
>> My understanding is the "fix" in the driver was to blacklist ncq for
>> that controller. I have not verified that yet.
>
> One of my disks died again a while ago. So I went to the machine to
> replace the drive. But I forgot to write down which one had died. So I
> started it up again. Now I had 7 disks again like before, but a
> different drive was now "gone". So my RAID had only 6 out of 8 drives
> and was "gone". Together with some 4.7T worth of data on it....
>
> Next I went to the machine with a spare sata card. I removed the
> drives from the ASUS U3S6 card, and put them on the old pci sata card.
>
> By the time I logged in on the machine, the RAID had found 8/8 drives
> and I think it had already started rebuilding.....
>
> I now haven't had any problems with the drives in more than a week.
>
> Performance of the raid has dropped from 600Mb to around 400Mb/sec,
> obviously because the PCI card cannot handle 200Mb/sec of disk IO.
>
> I'm open to suggestions for cheap highperformance WORKING PCIe sata
> cards....

I found that if I ran the latest of Linus' kernels, the controller worked 
correctly.  There is obviously a change that needs to get backported into 
the other working kernels.

-- 
Truth is stranger than fiction because fiction has to make sense.
