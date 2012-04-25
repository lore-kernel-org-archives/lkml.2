Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2DYJhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:37:51 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51562 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975Ab2DYJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:37:48 -0400
Message-ID: <4F97C5E0.1050808@stericsson.com>
Date: Wed, 25 Apr 2012 11:37:36 +0200
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
References: <20120423101804.GA8318@opensource.wolfsonmicro.com> <4F953455.3080002@stericsson.com> <20120423110522.GB8318@opensource.wolfsonmicro.com> <4F95495D.4050508@stericsson.com> <20120423122555.GM8318@opensource.wolfsonmicro.com> <4F954ED6.2040201@stericsson.com> <20120423180140.GR8318@opensource.wolfsonmicro.com> <4F965FC4.7010502@stericsson.com> <20120424105603.GA12063@opensource.wolfsonmicro.com> <4F969FE8.7040500@stericsson.com> <20120425080226.GA3195@opensource.wolfsonmicro.com>
In-Reply-To: <20120425080226.GA3195@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 10:02 AM, Mark Brown wrote:
> On Tue, Apr 24, 2012 at 02:43:20PM +0200, Ulf Hansson wrote:
>
>> So if grabbing a reference, there is no good point in the code were
>> I can drop it. Moreover _every_ host driver needs to handle this. It
>> will likely become a "hack" is my first impression.
>
> If it's something that every host driver needs to do then just factor it
> into the framework and we're done...  The stuff you're trying to put in
> the regulator API feels equally like it's a bodge and it seems to me
> like we've just not thought of the best way for the MMC stack to figure
> out and keep track of if it needs a regulator or not.
>
>>> This just seems awfully fragile and very much dependant on things like
>>> having the driver actually enabled to clean up later.
>
>> Setting this constraint is not done be "default", it could be
>> clearly be stated that the consumer must handle the enable/disable,
>> otherwise the regulator will be left in the state it was when the
>> kernel booted.
>
> Right, but the whole point in having full constraints is to avoid that.
> Users are supposed to set constraints to grant permissions for things,
> not to work around internal problems in the rest of the stack.  If I
> could see a general use case for the feature...  but I'm having trouble
> doing that.

Maybe you have convinced me now :-) I will therefore start thinking of a 
patch on the mmc framework instead. I will include you if/when I send 
out the patch to the mmc-list, just for reference if that is ok with you?

Some final thoughts (please comment if you like):
We already have the boot_on constraint, which to me is similar to what a 
new kind of "boot keep state" constraint would be. I think it would be 
no more odd than what boot_on already is. Maybe not a good argument, but 
still..


Kind regards
Ulf Hansson
