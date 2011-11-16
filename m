Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab1KPRTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:19:54 -0500
Received: from smtp-out-055.synserver.de ([212.40.185.55]:1259 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755127Ab1KPRTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:19:53 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4797
Message-ID: <4EC3F0DC.9090106@metafoo.de>
Date: Wed, 16 Nov 2011 18:20:28 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 2/7] regmap: Make reg_config reg_defaults const
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-2-git-send-email-lars@metafoo.de> <20111116161316.GI29986@opensource.wolfsonmicro.com> <4EC3E385.4060006@metafoo.de> <20111116162442.GL29986@opensource.wolfsonmicro.com> <4EC3E684.90109@metafoo.de> <20111116163908.GN29986@opensource.wolfsonmicro.com> <4EC3E9E5.7030909@metafoo.de> <20111116165151.GO29986@opensource.wolfsonmicro.com> <4EC3EC74.9040706@metafoo.de> <20111116170906.GQ29986@opensource.wolfsonmicro.com>
In-Reply-To: <20111116170906.GQ29986@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 06:09 PM, Mark Brown wrote:
> On Wed, Nov 16, 2011 at 06:01:40PM +0100, Lars-Peter Clausen wrote:
>> On 11/16/2011 05:51 PM, Mark Brown wrote:
> 
>>> None of them, I just changed the code to make the defaults const - I'm
>>> just reviewing by eyeball as I'm well aware of the fact that this isn't
>>> const.
> 
>> So you only applied part of the patch and are complaining that it you get an
>> error?
> 
> I'm saying that the way we're using the reg_defaults is unfortunately
> excessively cute right now so just by looking at the code I'm able to
> see that there's an issue having done the same change before but not
> applied it due to the cuteness.  I only did a code mod to generate the
> warnings since you weren't seeing any issue.

Sorry, I can't follow you anymore. Do you still see a problem with the patch
as it is, and if yes why?

We never ever modify reg_defaults of the reg_config we only ever modify the
reg_defaults of the regmap struct which is always runtime allocated. In the
case the config contains reg_defaults it is kmemdup'd into the reg_defaults
of the regmap struct.

