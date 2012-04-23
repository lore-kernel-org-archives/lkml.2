Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2DWMWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:22:08 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:35785 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443Ab2DWMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:22:06 -0400
Message-ID: <4F95495D.4050508@stericsson.com>
Date: Mon, 23 Apr 2012 14:21:49 +0200
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
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com> <20120423101804.GA8318@opensource.wolfsonmicro.com> <4F953455.3080002@stericsson.com> <20120423110522.GB8318@opensource.wolfsonmicro.com>
In-Reply-To: <20120423110522.GB8318@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 01:05 PM, Mark Brown wrote:
> On Mon, Apr 23, 2012 at 12:52:05PM +0200, Ulf Hansson wrote:
>
>> I realize that using boot_on, which has been around for quite some
>> time could have problems.  If not using the existing boot_on
>> constraint, do you have an idea of how to accomplish what I want?
>> Should I invent a new constraint option to be used in
>> regulator_init_complete!?
>
> To be honest I don't entirely understand what your goal is at the system
> level - the current idea is that either the regulator will be marked as
> always_on or it should be enabled by a consumer.  What is the scenario
> in which neither of these is sufficient?

The consumer do not want to enable the regulator directly from its 
device probe routine, it is handled through a scheduled work.

Moreover the regulator shall not be switched off unless the consumer 
work decides that this is OK.

So, we actually will have a race were the work _might_ be able to 
preventing the late_init_call (regulator_init_complete) from disabling 
the regulator if has reached the point were it has enabled the regulator.

Hopes this clarifies the background a bit more.


Kind regards
Ulf Hansson

