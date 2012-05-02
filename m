Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2EBUYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:24:08 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:36729 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2EBUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:24:06 -0400
Message-ID: <4FA197DD.8030702@genband.com>
Date: Wed, 02 May 2012 14:23:57 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: why would irq0 have many many more interrupts than LOC?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2012 20:23:58.0767 (UTC) FILETIME=[814B8BF0:01CD28A1]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18880.001
X-TM-AS-Result: No--6.822100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have an x86_64 2.6.27 kernel running on a Sandy Bridge machine.

/proc/interrupts currently shows 75573114 counts for irq0 on cpu 0 and 
no counts on other cpus and between 2973587 and 4185923 counts for "LOC" 
spread across all cpus including cpu0.

The following are enabled.

CONFIG_GENERIC_HARDIRQS=y
CONFIG_PREEMPT_SOFTIRQS=y
CONFIG_PREEMPT_HARDIRQS=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_HZ_1000=y
CONFIG_HZ=1000


It almost seems like it's taking a timer interrupt on cpu0 for every 
local timer interrupt on every cpu.  Surely that's not design intent?

Any ideas on how to fix this?

Chris



-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
