Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1G1RJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:09:01 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:47690 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab1G1RI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:08:58 -0400
Message-ID: <4E319781.9000405@genband.com>
Date: Thu, 28 Jul 2011 11:08:17 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RFC: generic support for two-stage watchdogs?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jul 2011 17:08:19.0072 (UTC) FILETIME=[F2A40000:01CC4D48]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18290.000
X-TM-AS-Result: No--6.040900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When using kdump to store crash recovery information, it is frustrating 
when the watchdog timer fires and reboots the system under our feet.

Many hardware watchdogs support a two-stage operation where the initial 
stage expires and sends an NMI or other interrupt to the CPU.  Only once 
the second stage fires does it actually reboot the hardware.

Has anyone considered adding support for this sort of hardware to the 
/dev/watchdog API?  It seems like it would make sense to reset the 
watchdog timeout to some suitable period and trigger kdump.  This would 
let us preserve the crash information.

If the system is really fubared then the second stage will fire and 
reboot the machine.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
