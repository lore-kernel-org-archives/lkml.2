Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231Ab2B1LTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:19:39 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:30143 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2B1LTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:19:38 -0500
Message-ID: <4F4CB824.5010801@atmel.com>
Date: Tue, 28 Feb 2012 12:19:00 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] at91 first cleanup series for 3.4
References: <4F4674F2.8090603@atmel.com> <201202271731.03230.arnd@arndb.de>
In-Reply-To: <201202271731.03230.arnd@arndb.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 06:31 PM, Arnd Bergmann :
> On Thursday 23 February 2012, Nicolas Ferre wrote:
>> This series removes the at91_sys_read/write() functions that where
>> used for all System Controller devices. The static offsets that were
>> used prevented us from compiling several AT91 SoC support in a single
>> zImage.
>>
>> The other cleanup is the move of some early console initialization. In
>> addition, some Makefile.boot modifications have been performed to be
>> able to make .dtb files.
>>
>> All this goes on top of current material that is already in arm-soc
>> git tree (merge of all at91/* branches. You can find it in the same git
>> tree with at91-3.4-base2 branch name).
>>
>>
>> The following changes since commit 11a25ea7e4f870a37093258f577e11cec703e37e:
>>
>>   Merge remote-tracking branch 'armsoc/at91/9x5' into at91-3.4-base2 (2012-02-11 14:33:03 +0100)
>>
>> are available in the git repository at:
>>
>>
>>   git://github.com/at91linux/linux-at91.git at91-3.4-base2+cleanup
> 
> Hi Nicolas,
> 
> I cannot merge this into the next/cleanup branch because you have based it
> on top of a non-cleanup branch. There are three ways out of this:
> 
> 1. rebase the entire branch on a changeset that only contains upstream and
> cleanup branches, and let me deal with merge conflicts against the at91/9x5
> branch.

Not only at91/9x5 branch but also at91/pm_cleanup

> 2. Split this series into two parts, with the simple cleanups going directly
> in as in 1, but cleanups on top of the at91/9x5 branch get applied to that
> branch only.

The issue with this is that we remove entirely some functions: it is the
goal of this series. So it will be difficult to split it...

It bothers me a little bit to artificially split a logical series of
patches just because it should stand on top of unrelated branches...

Yes this series is dependent on material already pulled in arm-soc for
AT91 during this cycle, but I think it is still better to try to
integrate patches "early and often".

> 3. Create a new next/cleanup2 branch with this pull request that I submit
> to Linus separately from the other cleanups.

Yes, maybe it is the way to go. It is very AT91 specific and this
cleanup spread across all AT91 SoCs and platforms. Why not create an
at91/devel branch with all at91 material + this cleanup branch?

The problem that I see now is that it sounds difficult to build
incremental enhancements during a development cycle: for example, I have
several patch series which deals with the device tree that will go on
top of this "cleanup" branch. The questions are: which branch should I
base my work upon? Will you be able to manage those incremental
dependencies as it seems already difficult to deal with what will be the
base of our 3.4 DT work?

> I'm also still not entirely happy with the contents because the newly
> introduced macros all still use __raw_readl() instead of readl_relaxed(),

This "cleanup" series was not meant to modify this in addition to the
removal of at91_sys_xxx() functions. It has already been a long effort
and we do not want to mix all modifications together.
I think that Jean-Christophe already told you that, BTW.

> and because the rtt setup appears unnecessarily complex while at the same
> time still not sufficient for a combined at91 kernel. It would be nice

Well, complexity of this code is pretty low and I do not see a simple
way to deal with this (resource with/without drivers, multiple resources
on some SoC / single on another, etc.).

> if those could be fixed, but I would still take the series without changing
> the rtt code because we have not really come to a conclusion otherwise
> and the series generally moves things into the right direction.

Ok, thanks.

> I've applied your series to the staging/cleanup branch for now, which
> means it gets into linux-next but I won't send to Linus unless I get
> an update.

So, tell me if you can create a next/cleanup2 (or any kind of "devel")
branch with this pull request. In addition, can you please give me
advice for my future work that is dependent on this series (and Grant's
irqdomain work actually)...

Best regards,
-- 
Nicolas Ferre
