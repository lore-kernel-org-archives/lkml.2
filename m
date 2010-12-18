Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0LRFu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 00:50:29 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3237 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0LRFu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 00:50:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6200"; a="67338746"
Message-ID: <c472e9529b53486845cc4c1554b68e7d.squirrel@www.codeaurora.org>
In-Reply-To: <20101217114430.GB31453@rakim.wolfsonmicro.main>
References: <3bf69fb1c4f33c8a1f405b4f05ba1a59.squirrel@www.codeaurora.org>
    <20101217114430.GB31453@rakim.wolfsonmicro.main>
Date: Fri, 17 Dec 2010 21:50:15 -0800 (PST)
Subject: Re: [PATCH 2/2] regulator: Optimise out noop voltage changes
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Liam Girdwood" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
>> 2. When I was trying to do the above this Sunday, I also noticed what
>> looks like a bug or at least an unpleasant behavior. A consumer's min_uV
>> and max_uV were being updated (for-next around Dec 12th) before calling
>> the producer's set voltage. So, in the above example, if consumer C
>> comes
>> in and asks for (10 - 15), it will prevent the producer voltage from
>> ever
>> changing again. All of consumer A and B's future requests will result in
>> a
>> failure since min_uV > max_uV when you do the consumer aggregation.
>
> I'm sorry I can't parse this at all.  What is a producer?
>
> If the consumers are all asking for incompatible things there's a system
> integration issue and the consumers need to be sorted out; it's
> difficult for the regulator API to do anything safely while everything
> wants incompatible configurations.

Sorry for the confusing explanation. Like I said, I didn't have access to
the code and I was using terms I had in my head. Anyway, wrote a quick
patch and sent it your way. Think of it more as an RFC to explain my point
-- I'm more than willing to implement it differently if you don't like it.

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


