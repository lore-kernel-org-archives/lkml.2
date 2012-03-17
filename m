Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032951Ab2CQAzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:55:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64642 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032168Ab2CQAy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:54:58 -0400
Message-ID: <4F63E0D3.3060106@gmail.com>
Date: Fri, 16 Mar 2012 19:54:43 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Paul Walmsley <paul@pwsan.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linaro-dev@lists.linaro.org, Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com> <201203161218.05125.arnd.bergmann@linaro.org> <201203162057.58706.arnd@arndb.de> <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com> <20120316234706.GJ3852@pengutronix.de>
In-Reply-To: <20120316234706.GJ3852@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 06:47 PM, Sascha Hauer wrote:
> Hi Paul,
> 
> On Fri, Mar 16, 2012 at 04:21:17PM -0600, Paul Walmsley wrote:
>> Hi
>>
>> On Fri, 16 Mar 2012, Arnd Bergmann wrote:
>>
>>
>> If the common clock code is to go upstream now, it should be marked as 
>> experimental.
> 
> No, please don't do this. This effectively marks the architectures using
> the generic clock framework experimental. We can mark drivers as 'you
> have been warned', but marking an architecture as experimental is the
> wrong sign for both its users and people willing to adopt the framework.
> Also we get this:
> 
> warning: (ARCH_MX1 && MACH_MX21 && ARCH_MX25 && MACH_MX27) selects COMMON_CLK which has unmet direct dependencies (EXPERIMENTAL)
> 
> (and no, I don't want to support to clock frameworks in parallel)
> 

+1

For simple users at least, the api is perfectly adequate and it is not
experimental (unless new means experimental).

Rob

>> This is because we know the API is not well-defined, and 
>> that both the API and the underlying mechanics will almost certainly need 
>> to change for non-trivial uses of the rate changing code (e.g., DVFS with 
>> external I/O devices).
> 
> Please leave DVFS out of the game. DVFS will use the clock framework for
> the F part and the regulator framework for the V part, but the clock
> framework should not get extended with DVFS features. The notifiers we
> currently have in the clock framework should give enough information
> for DVFS implementations. Even if they don't and we have to change
> something here this will have no influence on the architectures
> implementing their clock tree with the common clock framework.
> 
> Sascha
> 

