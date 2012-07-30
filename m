Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2G3Wkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:40:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22665 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2G3Wki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:40:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6788"; a="216111423"
Message-ID: <50170D65.4080205@codeaurora.org>
Date: Mon, 30 Jul 2012 15:40:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] ARM: Sort exception table at compile time
References: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org> <20120730215118.GA32670@merkur.ravnborg.org> <20120730221911.GB10335@n2100.arm.linux.org.uk>
In-Reply-To: <20120730221911.GB10335@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/12 15:19, Russell King - ARM Linux wrote:
> On Mon, Jul 30, 2012 at 11:51:18PM +0200, Sam Ravnborg wrote:
>> Here you should be able to use the macro EXCEPTION_TABLE from
>> vmlinux.lds.h.
>> I cannot see why the ifdef for not NON-MMU case is needed,
>> but if it is needed the macro is not good...
> Because you can not mention the same input section in two different
> places and end up with predictable output from the linker.
>
> We discard the __ex_table for noMMU, but I think the start/stop
> symbols are still referenced somewhere.  Dunno, I don't have much to
> do with noMMU ARM, and the only platform I'd be interested in never
> got merged.

I was thinking, perhaps we can ifdef out the exception fixup sections in
the places where they're added? Then we can just use the EXCEPTION_TABLE
macro from vmlinux.lds.h knowing that there are no __ex_table sections
in the input object files?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

