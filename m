Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0LLMlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:41:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63016 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0LLMlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:41:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6194"; a="66503767"
Message-ID: <d681667c87585c281d0330c030c97025.squirrel@codeaurora.org>
In-Reply-To: <20101212121842.GC15189@opensource.wolfsonmicro.com>
References: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
    <20101212121842.GC15189@opensource.wolfsonmicro.com>
Date: Sun, 12 Dec 2010 04:41:04 -0800 (PST)
Subject: Re: [PATCH] regulator: Call into regulator driver only when 
     voltage min/max really changes.
From: skannan@codeaurora.org
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Liam Girdwood" <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Dec 12, 2010 at 02:55:40AM -0800, Saravana Kannan wrote:
>> Even in cases where the consumer driver calls the regulator core with
>> different voltage min/max values, the application of the various
>> voltage constraints could result in the min/max voltage values passed
>> to the regulator driver to be unchanged since the previous invocation.
>
> Out of interest do we have any examples of consumers that do this
> sufficiently often and/or in paths sufficiently performance critical for
> it to be an issue?  Sounds like there might be room for optimisation in
> those consumers.

Wouldn't it be better to optimize in one location (the core), instead of
optimizing in several consumers?

I probably should have mentioned this too -- The other case this optimizes
is the consumer calling with the same values. It can happen during CPU
frequency scaling where multiple frequencies might have the same voltage
level.

>> Optimize these cases by not calling into the regulator driver and not
>> sending incorrect/unnecessary voltage change notifications.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> The down side of doing this is that if the regulator state changes
> underneath us we've now got no way of recovering from that situation.
> This is something that's only partially supported by the API at the
> minute but it's nice to have a story about how drivers can work with
> this.  I'll send a patch adding an explicit sync API.

Would this be a problem irrespective of this optimization?

Btw, after sending this patch, I just realized there might be another
"bug" in the existing code (not my changes). What's the meaning of the
"voltage change" event? It appears to be sent even if the regulator driver
fails to set the voltage. It would be correct if the event just means
"someone called set_voltage", but that seems like an unlikely definition.
Let me know if I should send in a patch for that too.

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


