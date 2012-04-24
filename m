Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2DXQnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:43:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48477 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756742Ab2DXQnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:43:10 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18Upxc615AUNx+diDqss4h38vPqax8ISnsU20dcG/
	t2JgC20bqWV7Ry
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: hibernate a system booted from external USB drive - is it posible?
Date: Tue, 24 Apr 2012 18:42:52 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.3; KDE/4.8.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201204221849.31198.toralf.foerster@gmx.de> <4F943AE1.5050207@msgid.tls.msk.ru>
In-Reply-To: <4F943AE1.5050207@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204241842.53014.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michael Tokarev wrote at 19:07:45
> On 22.04.2012 20:49, Toralf Förster wrote:
> > I wonder, whether it is expect to work with current stable kernel 3.3.2
> > or not. Seems not to work here (s2ram works fine).
> > Hibernate however writes data to the swap partition, but during wakeup I
> > get :
> > 
> > kernel: PM: Hibernation image partition 8:6 present
> > kernel: PM: Looking for hibernation image.
> > kernel: PM: Image not found (code -22)
> > kernel: PM: Hibernation image not present or could not be loaded.
> 
> This is entirely an initramfs issue/question.  The device should be
> present in early userspace when it attempts to resume.  
> 
Yes - that its. I do not have an initrd, just buikding linux kernel from git :

$> make -j 3 && sudo su -c "mount /boot/; make modules_install && cp arch/i386/boot/bzImage /boot/linux-git"

which works well for a cold start, but during wakeup I get :

...
PM: Checking hibernation image partition /dev/sdb2
...
	then the internal sda are recognized
...
PM: Hibernation image not present or could not be loaded.
Waiting 15sec before mounting root device...
...
	now the USB devices are recognized>


 - too late for me  :-(

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
