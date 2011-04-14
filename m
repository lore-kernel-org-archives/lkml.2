Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab1DNLT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:19:57 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:36990 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1DNLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:19:56 -0400
Message-ID: <4DA6D85A.8000800@wildgooses.com>
Date: Thu, 14 Apr 2011 12:19:54 +0100
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Improved TSC calculation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thanks for the new stable TSC calculation commit
(08ec0c58fb8a05d3191d5cb6f5d6f81adb419798).

My situation is that I don't have a PM or HPET timer (x86 Alix board),
and my requirements are embedded type use, but with only intermittently
connected network/gps, so accurate timekeeping between reboots is
important.

I had been experimenting with extending the existing PIT timer routines
at boot, but I had the problem that it was taking 1s+ to get a very
stable calculation (which is undesirable for my requirements), however,
having spotted your commit it seems like a much more sensible solution.

Before I try and hack probably an (inadequate) solution myself, do you
have any thoughts on the best solution to extend your commit to non
PM/HEPT machine?  My initial thought was to repeatedly call
pit_calibrate_tsc() with an extended latch, looking for a stable
solution (ie refactor native_calibrate_tsc() ).  Is this workable?
Better ideas?

Thanks

Ed W
