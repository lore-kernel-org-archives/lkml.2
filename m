Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2HQKXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:23:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45122 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757384Ab2HQKX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120817095837.GM18957@n2100.arm.linux.org.uk>
References: <1345196843-23059-1-git-send-email-richard.genoud@gmail.com> <20120817095837.GM18957@n2100.arm.linux.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 17 Aug 2012 12:23:06 +0200
Message-ID: <CACQ1gAh3YcMBXp7BFoR68+rdDM1PEe4fenNG77s=SP05RditEA@mail.gmail.com>
Subject: Re: [PATCH] BUG: clk_find() misses some clocks
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/17 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> Please read the comments on the function:
>
>  * Find the correct struct clk for the device and connection ID.
>  * We do slightly fuzzy matching here:
>  *  An entry with a NULL ID is assumed to be a wildcard.
>  *  If an entry has a device ID, it must match
>  *  If an entry has a connection ID, it must match
>  * Then we take the most specific entry - with the following
>  * order of precedence: dev+con > dev only > con only.
>
> On Fri, Aug 17, 2012 at 11:47:23AM +0200, Richard Genoud wrote:
>> if a clock is declared like that:
>> CLKDEV_CON_DEV_ID("pioA", "fffff400.gpio", &pioAB_clk)
>
> So you've declared it with a connection ID.  Therefore, as the comment
> above says, "it must match" what the driver is asking for.
>
> It's not a bug, this is done intentionally so that mismatches do not
> occur.
Ok, so I have to declare it like that :
CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk)

Got it !
Thanks.

Richard.

-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
