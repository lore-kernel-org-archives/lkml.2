Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0GNSGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:06:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23184 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0GNSF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:05:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6043"; a="47476437"
Message-ID: <4C3DFC7A.8020002@codeaurora.org>
Date: Wed, 14 Jul 2010 11:05:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brownell <david-b@pacbell.net>
Subject: Meaning of clk_round_rate()?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  What is the meaning of clk_round_rate() in the clk API 
(include/linux/clk.h)? The function documentation says "adjust a rate to 
the exact rate a clock can provide". That seems pretty vague. I'm lead 
to believe that it rounds the rate to the closest rate supported. Is 
that correct? Is there some sort of error margin where beyond that it's 
no longer possible to be rounded? 0.5%? 1%?

Assuming it's doing closest matching, I don't see how it's very useful 
in practice. Some users of clk_round_rate() are blindly searching up and 
down in the frequency space until they find a suitable rate (see 
sound/atmel/abdac.c and sound/spi/at73c213.c). These drivers might be 
better served by something like a clk_round_rate_up() and a 
clk_round_rate_down() which would round the rate to the nearest higher 
and lower frequency respectively without requiring complex loops around 
clk_round_rate().

In addition, an up/down rounding approach would make it simpler for 
drivers to find a min/max rate (for example display panels have a max 
frequency they can support).

A similar approach was suggested by David Brownell [1] but nothing came 
of it.

[1] http://article.gmane.org/gmane.linux.ports.arm.kernel/38076

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

