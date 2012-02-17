Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2BQNoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:44:07 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:28826 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2BQNoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:44:06 -0500
Date: Fri, 17 Feb 2012 14:44:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
Message-ID: <20120217134404.GA11353@merkur.ravnborg.org>
References: <4F3E42E0.4030108@openvz.org> <20120217120815.25909.15632.stgit@zurg> <20120217234508.8293a84fb3ebb7fed6d60ec3@canb.auug.org.au> <4F3E56DA.3050203@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3E56DA.3050203@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 05:32:10PM +0400, Konstantin Khlebnikov wrote:
> Stephen Rothwell wrote:
>> Hi Konstantin,
>>
>> On Fri, 17 Feb 2012 16:08:15 +0400 Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>>>
>>> Config NUMA must be defined for all architectures,
>>> otherwise IS_ENABLED(CONFIG_NUMA) does not work.
>>> Some arch-specific Kconfig already has this stub.
>>> This patch adds it to all remaining.
>>
>> Why not add it somewhere generic (like mm/Kconfig, maybe) and then it can
>> be removed from the architecture specific places over time (if necessary
>> - I am pretty sure it is ok to have it there twice)?
>>
>
> Different architectures has different dependencies for NUMA.
>
> Seems like Kconfig allow config option duplication, but it use default state from first.
> If we add "config NUMA\n def_bool n" somewhere in generic Kconfig, default will be n if
> Kconfig see this declaration first.
Correct.
And as n is default there is no need to specify it.
But please add a help text that explain the symbol - even if it is not
visible in menuconfig.

	Sam
