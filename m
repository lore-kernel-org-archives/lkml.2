Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2DTIkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:40:22 -0400
Received: from mail.pr.hu ([87.242.0.5]:35891 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2DTIkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:40:15 -0400
X-Greylist: delayed 2933 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 04:40:14 EDT
Message-ID: <4F911568.7050601@pr.hu>
Date: Fri, 20 Apr 2012 09:51:04 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: VESA and VGA16 framebuffer drivers clash sometimes
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.8 (--)
X-Scan-Signature: d715e2383c66dfab752a5ffb3bca881e
X-Spam-Tracer: backend.mail.pr.hu -2.8 20120420075055Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on an embedded x86 board with Intel Atom, text on vesafb
gets distorted if both vesafb and vga16fb are compiled in.
The strange thing is that it doesn't happen all the time but
about once out of 15 boots.

The distortion looks like this:
http://www.postgresql-support.de/private/IMG_7221.jpg

The relevant kernel messages:

Apr 13 11:14:30 term002 kernel: vesafb: mode is 800x600x16, linelength=1600, pages=7
Apr 13 11:14:30 term002 kernel: vesafb: scrolling: redraw
Apr 13 11:14:30 term002 kernel: vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Apr 13 11:14:30 term002 kernel: vesafb: framebuffer at 0xa0000000, mapped to 0xdf580000, 
using 1875k, total 8128k
Apr 13 11:14:30 term002 kernel: Console: switching to colour frame buffer device 100x37
Apr 13 11:14:30 term002 kernel: fb0: VESA VGA frame buffer device
Apr 13 11:14:30 term002 BOOTLOG: Terminal startup
Apr 13 11:14:30 term002 kernel: vga16fb: mapped to 0xc00a0000
Apr 13 11:14:30 term002 kernel: fbcon: VGA16 VGA (fb1) is primary device
Apr 13 11:14:30 term002 kernel: fbcon: Remapping primary device, fb1, to tty 1-63
Apr 13 11:14:30 term002 kernel: fb1: VGA16 VGA frame buffer device

It's strange that vga16fb is always detected as primary
and vesafb gets remapped to fb1 even when there is no
screen distortion. The kernel is compiled for SMP.

Best regards,
Zoltán Böszörményi

