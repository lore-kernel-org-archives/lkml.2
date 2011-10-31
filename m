Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1JaVVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:21:22 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:54695 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1JaVVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:21:21 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 17:21:21 EDT
Message-ID: <4EAF1021.2090004@tlinx.org>
Date: Mon, 31 Oct 2011 14:16:17 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: ACPI ERROR SMBus or IPMI write requires Buff of len 66, found 32...???? linux-3.0.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Was looking through boot log messages, and this one seemed 'new'...

is this saying that the device requires 66, but the driver allocated 32 
bytes?

Or the opposite: i.e. driver requires 66 (according to some new 
standard**) but the
device from 2009, has the 2009 standard of 32?

Just a WAG, but 20110413 looks like a date, that is certainly newer than 
the system, though
it has had firmware upgrades (though none in the past 6 months or so...)...

Seems like a weird thing to be changed across drivers while not 
providing for some backward
compat, but that's purely based on a notion that there's a driver/hw 
version mismatch now
when before, there were no such error messages (maybe the error message 
is new, and it's
always been broken? ;-) )...

as subj says linux-3.0.0, stock vanilla + the latest IMQ networkfilter 
patch.
X64

[   13.722612] ACPI Error: SMBus or IPMI write requires Buffer of length 
66, found length 32 (20110413/exfield-285)
[   13.733078] ACPI Error: Method parse/execution failed 
[\_SB_.PMI0._GHL] (Node ffff880616962b18), AE_AML_BUFFER_LIMIT 
(20110413/psparse-536)
[   13.746189] ACPI Error: Method parse/execution failed 
[\_SB_.PMI0._PMC] (Node ffff880616962a78), AE_AML_BUFFER_LIMIT
[   13.755322] dca service started, version 1.12.1[   13.761822]  
(20110413/psparse-536)
[   13.765509] ACPI Exception: AE_AML_BUFFER_LIMIT, Evaluating _PMC 
(20110413/power_meter-773)

Did something that would cause this?  I haven't determined what the 
impact of the above
problem is -- it might be some status progs no longer work OR maybe 
never worked, and now
may have a clue... ?   Any insights?



