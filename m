Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1CWVsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:48:55 -0400
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:54065 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698Ab1CWVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:47:57 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Mar 2011 17:47:57 EDT
Message-ID: <4D8A668B.9070302@gmail.com>
Date: Wed, 23 Mar 2011 22:30:51 +0100
From: =?ISO-8859-15?Q?Ren=E9_Herman?= <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Lanikai/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG 2.6.38] drm/i915: rampant video-corruption on Intel 865G
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1Q2VcG-0003Mi-EX
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=-5.109, vereist 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, FREEMAIL_FROM 0.50, PROLO_TRUST_RDNS -3.00,
	PROLO_TRUST_TO_DIRECT -3.48, RDNS_DYNAMIC 0.98, SPF_NEUTRAL 0.78,
	TO_NO_BRKTS_DIRECT 1.00, TO_NO_BRKTS_DYNIP 1.00,
	T_TO_NO_BRKTS_FREEMAIL 0.01)
X-ZiggoSMTP-MailScanner-From: rene.herman@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

2.6.38 (-final) unfortunately is largely unusable on Intel 865G, and 
more old Intel graphics hardware as reported for example for Debian on 
855G at:

http://www.linux-archive.org/debian-kernel/503229-bug-619022-linux-image-2-6-38-1-686-screen-corruption-i855.html

Most web pages won't render without corrupting, nor does scrolling a 
terminal a few times. I see from the above Debian report that it is/was 
known but it's indeed not fixed in final on 855/865 by anything which 
may have happened in response.

I do not have the time currently to fully bisect this and I assume it's 
known what the culprit is going to be anyway; I could revert specific 
commits on command and/or test fixes on top of 2.6.38-final; for know 
I've simply reverted to 2.6.37.4 where everything is fine.

(PS: most people using graphics hardware this plain/old will not deeply 
care for graphics; I in fact once bought the machine specifically with 
the "well supported, no-thrills" basic, integrated Intel graphics as a 
reason but it has given me only grief in that department, with years of 
X11 instability. This older hardware seems to receive little or no 
testing from the Intel graphics developers and if it's holding back 
development, I expect most users would not not mind or even welcome it 
being split of into a separate, maintained but no longer "improved" 
driver, both kernel- and X11-side).

00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM 
Controller/Host-Hub Interface (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated 
Graphics Controller (rev 02)
00:03.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to CSA Bridge (rev 02)
00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to 
I/O Memory Interface (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC 
Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller 
(rev 02)
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus 
Controller (rev 02)
00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER 
(ICH5/ICH5R) AC'97 Audio Controller (rev 02)
02:01.0 Ethernet controller: Intel Corporation 82547EI Gigabit Ethernet 
Controller

Regards,
Rene
