Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab1IHKpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 06:45:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:38677 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab1IHKpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 06:45:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kristoff Bonne <kristoff.bonne@skypro.be>
Subject: [Question]  FastFPE math emulation
Date: Thu, 08 Sep 2011 12:42:07 +0200
Message-ID: <j4a65v$75v$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 91.181.69.100
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am playing around with a "friendlyarm mini2440" development board.
It's a system based on a 400 Mhz samsung s3c2440 CPU, which is itself
based on a ARM920T core.
This system does not have a FPU. (nor integer DSP instruction-set).


I want to experiment to use this board for audio-related application,
e.g. the codec2 vocoder.
The implementation of that codec is now based on floating-point math.

First tests indicate that, using default settings, the board is not fast
enough to do realtime encoding or decoding of codec2 . (encoding a 34
second audio-sample takes 42 seconds).


Yesterday, I noticed the kernel has an option "FastFPE math emulation"
but when I install a kernel with that option enabled, I see no
difference at all.

- does FastFPE work on this kind of CPU.
- Is there something that needs to be done to activate it? (setting,
option during compiling, ...?)


Info:
# uname -a
Linux FriendlyARM 2.6.32.2-FriendlyARM #9 Wed Sep 7 21:38:49 CEST 2011
armv4tl unknown

$ grep -i fpe .config
CONFIG_FPE_NWFPE=y
# CONFIG_FPE_NWFPE_XP is not set
CONFIG_FPE_FASTFPE=y


# cat /proc/cpuinfo
Processor	: ARM920T rev 0 (v4l)
BogoMIPS	: 201.93
Features	: swp half
CPU implementer	: 0x41
CPU architecture: 4T
CPU variant	: 0x1
CPU part	: 0x920
CPU revision	: 0

Hardware	: FriendlyARM Mini2440 development board
Revision	: 0000
Serial		: 0000000000000000



http://friendlyarm.net/products/mini2440?lang=en
http://codec2.org/


Cheerio!
Kr. Bonne.

