Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2KMROk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:14:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37693 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2KMROg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:14:36 -0500
Message-ID: <50A27FF8.3080905@wwwdotorg.org>
Date: Tue, 13 Nov 2012 10:14:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [PATCH V2 2/11] time: convert arch_gettimeoffset to a pointer
References: <1352753462-2915-1-git-send-email-swarren@wwwdotorg.org> <50A16BD3.5010707@us.ibm.com>
In-Reply-To: <50A16BD3.5010707@us.ibm.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 02:36 PM, John Stultz wrote:
> On 11/12/2012 12:51 PM, Stephen Warren wrote:
>> Currently, whenever CONFIG_ARCH_USES_GETTIMEOFFSET is enabled, each
>> arch core provides a single implementation of arch_gettimeoffset(). In
>> many cases, different sub-architectures, different machines, or
>> different timer providers exist, and so the arch ends up implementing
>> arch_gettimeoffset() as a call-through-pointer anyway. Examples are
>> ARM, Cris, M68K, and it's arguable that the remaining architectures,
>> M32R and Blackfin, should be doing this anyway.
>>
>> Modify arch_gettimeoffset so that it itself is a function pointer, which
>> the arch initializes. This will allow later changes to move the
>> initialization of this function into individual machine support or timer
>> drivers. This is particularly useful for code in drivers/clocksource
>> which should rely on an arch-independant mechanism to register their
>> implementation of arch_gettimeoffset().
...
> One last thing to watch out for: If you're trying to build a kernel that
> mixes clocksource support with get_arch_timeoffset, you'll need to
> rework the #ifdef in update_wall_time(), since we currently assume with
> get_arch_timeoffset() that you're using tick + interpolation, so every
> call to update_wall_time() only moves time forward by one jiffy.

OK. I don't have any immediate plans to do that, although I wouldn't be
surprised if we (the ARM community in general) end up wanting to do that
at some point. It all depends on which ARM sub-architectures end up
getting converted to the multi-platform zImage support I guess.

> Otherwise, thanks for the name tweak. Going through the arm-soc tree is
> fine with me.
> 
> Acked-by: John Stultz <johnstul@us.ibm.com>

Thanks.
