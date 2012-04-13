Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934648Ab2DMJys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:54:48 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:36521 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758223Ab2DMJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:54:47 -0400
Message-ID: <4F87F7CD.4000004@stericsson.com>
Date: Fri, 13 Apr 2012 11:54:21 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com> <4F87EBFC.90000@stericsson.com> <20120413091828.GJ3168@opensource.wolfsonmicro.com>
In-Reply-To: <20120413091828.GJ3168@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 11:18 AM, Mark Brown wrote:
> On Fri, Apr 13, 2012 at 11:03:56AM +0200, Ulf Hansson wrote:
>
>> But, how should those amba drivers that implements runtime PM
>> support be able to switch of the vcore regulator during normal
>> suspend? In normal suspend case we can not use
>
> A generic AMBA driver should have no idea about the implementation of
> the particular SoC that it's integrated on to.  This applies even more
> to system suspend (where drivers can generally just assume that they
> will loose all power normally) than it does to runtime suspend.
>
>> pm_runtime_put/pm_runtime_put_sync to trigger the power domain
>> runtime functions to switch of vcore. This is kind of more generic
>> problem when dealing with power domains, but as said this patch will
>> have consequences.
>
> The power domain gets callbacks on the system suspend path too and can
> do whatever is sensible there.
>
>> As far as I can see, the power domain must then implement a
>> suspend_noirq function to make sure same things is done as for the
>> runtime_suspend function. Do you agree with this as well or is there
>> another option?
>
> Yes, the power domain should just be handling this transparently.

Alright, thanks for your confirmation. Let's see how this works out then.

Kind regards
Ulf Hansson
