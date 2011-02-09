Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1BIUlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:41:39 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:13110 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752845Ab1BIUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:41:38 -0500
Message-ID: <4D52FC1A.9090700@bluewatersys.com>
Date: Thu, 10 Feb 2011 09:42:02 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
References: <1297233693.242364.862698430999.1.gpush@pororo> <4D52F73A.4010707@bluewatersys.com> <20110209203900.GT27982@pengutronix.de>
In-Reply-To: <20110209203900.GT27982@pengutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2011 09:39 AM, Uwe Kleine-König wrote:
> Hi Ryan,
> 
> On Thu, Feb 10, 2011 at 09:21:14AM +1300, Ryan Mallon wrote:
>>> +int clk_enable(struct clk *clk)
>>> +{
>>> +	unsigned long flags;
>>> +	int ret = 0;
>>> +
>>> +	spin_lock_irqsave(&clk->enable_lock, flags);
>>
>> 	WARN_ON(clk->prepare_count == 0); ?
> This is added in patch 3/3

Ah, missed that. I still think that patch 3 should just be rolled into
patch 1. I don't see why we should add a new file in one patch and then
randomly add some warning code to it in another patch. It makes
reviewing harder for one thing :-).

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
