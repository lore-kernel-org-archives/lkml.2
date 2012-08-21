Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2HUJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:29:24 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:40029 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2HUJ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:29:21 -0400
Date: Tue, 21 Aug 2012 05:28:54 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Borislav Petkov <borislav.petkov@amd.com>, kvm-devel <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>
Message-ID: <592618508.2357204.1345541334852.JavaMail.root@redhat.com>
In-Reply-To: <5033371C.9040703@msgid.tls.msk.ru>
Subject: Re: [Qemu-devel] x86, nops settings result in kernel crash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.27.4]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 20.08.2012 21:13, Tomas Racek wrote:
> []
> Can we trim the old, large and now not-so-relevant discussion please?
> ;)
> 
> > I can provide you with more different traces if it can help. But I
> > thought that maybe it will be more useful for you to try it on
> > your own. So I've prepared some minimal debian installation which
> > you could download here (apx 163M bzipped):
> > 
> > http://fi.muni.cz/~xracek/debian.img.bz2
> > 
> > Password:
> > root/asdfgh
> > 
> > Here is my config for guest kernel:
> > 
> > http://fi.muni.cz/~xracek/config
> > 
> > I use
> > 
> > qemu-kvm -m 1500 -hda debian.img -kernel
> > linux/arch/x86/boot/bzImage -append "root=/dev/sda1"
> 
> Um.  I'd expect the image to be self-contained, no external kernel.
> I wanted to do a quick test to see if it fails on my machine too,
> d/loaded debian.img.bz2 but there's no kernel.  So.. no quick test
> for you ;)

Well, the point was to use the latest sources instead of some image which can be obsolete tomorrow. However I created a new image with today's kernel which you can use:

http://fi.muni.cz/~xracek/debian2.img.bz2

Other things are the same.

The runtest.sh sets environment for xfstests and runs test 285 which I wrote and and which should test if FS sends discard requests only on free sectors:
285:
1. Create loop device and FS on it.
2. Populate it with some garbage.
3. Get free sectors from FS.
4. Run fstrim and look for discard requests via blk tracer.
5. Compare free sectors to discard requests.

The test itself can have some issues but I'm pretty sure it shouldn't crash the system. ;-)

Regards,
Tom

> 
> > After logging in just run "sh runtest.sh". This leads to crash in
> > my case (host: Intel Core i5-2540M, kernel 3.5.2-1.fc17.x86_64,
> > qemu 1.0.1).
> 
> With all the above, this "runtest.sh" is informationally equal to
> your disk image.
> 
> /mjt
> 
