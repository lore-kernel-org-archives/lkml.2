Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2DWKwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:52:17 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:45299 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426Ab2DWKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:52:16 -0400
Message-ID: <4F953455.3080002@stericsson.com>
Date: Mon, 23 Apr 2012 12:52:05 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com> <20120423101804.GA8318@opensource.wolfsonmicro.com>
In-Reply-To: <20120423101804.GA8318@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for a quick reply.

On 04/23/2012 12:18 PM, Mark Brown wrote:
> On Mon, Apr 23, 2012 at 11:37:53AM +0200, Ulf Hansson wrote:
>
>> Regulators which has boot_on constraints set, will now remain
>> powered after regulator_init_complete is done.
>
> This would be a bug.  All boot_on means is that the regulator was turned
> on during boot, the regulator is free to vary after that.

The idea is to prevent the late_init_call "regulator_init_complete" from 
disabling a regulator that "recently" were enabled due to it's boot_on 
constraints.

>
>> In this case we leave the enable->disable operation to be
>> handled by the regulator consumer instead.
>
> Which would be a bug if the consumer wasn't the thing that took the
> reference to the regulator in the first place.  Remember, regulators can
> be shared so the consumer can't disable a regulator it didn't enable in
> the first place (unless it used regulator_get_exclusive() but the use
> cases for that are a little suspicious so it'd be worth taking a careful
> look before using it).  A consumer can't tell if the regulator was left
> enabled by the firmware on boot or if it has been enabled by another
> consumer.

I realize that using boot_on, which has been around for quite some time 
could have problems.  If not using the existing boot_on constraint, do 
you have an idea of how to accomplish what I want? Should I invent a new 
constraint option to be used in regulator_init_complete!?

Kind regards
Ulf Hansson
