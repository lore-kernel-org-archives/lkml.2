Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1HFW72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:59:28 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:45904 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1HFW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:59:26 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Aug 2011 18:59:26 EDT
Date: Sat, 6 Aug 2011 15:52:02 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org
Subject: powertop "pread cpu0 0xe8 : Bad file descriptor" fixed by
	CONFIG_MSR
Message-ID: <20110806225202.GO6058@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hadn't seen this issue discussed on the list, and I don't know of a
powertop mailing list, so here's what stymied my use of powertop until I
straced it.

With CONFIG_MSR=n, powertop "1.97-2" (from Debian unstable) on 3.0.1
(and presumably many other recent kernels) exits at startup with:

pread cpu0 0xe8 : Bad file descriptor

strace shows:

open("/dev/cpu/0/msr", O_RDONLY) = -1 ENOENT (No such file or directory)
pread(4294967295, 0x7fff4c8347c8, 8, 232) = -1 EBADF (Bad file descriptor)

Setting CONFIG_MSR=m and loading msr.ko fixes the issue, allowing
powertop to work again (tested against 3.0.1).  I'm pretty sure this is
a regression from long ago -- I have had CONFIG_X86_MSR=n in almost all
configs since 2.6.34-07097-gf4b87de, and powertop worked in most of
those kernels.  But I don't have references for what versions of
powertop and what kernels I was running at various points.

-andy
