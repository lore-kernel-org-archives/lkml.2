Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0K3AZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:25:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56645 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0K3AZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:25:09 -0500
Message-ID: <4CF443E1.606@oracle.com>
Date: Mon, 29 Nov 2010 16:22:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>,
        Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
References: <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>	<20101118082454.GC15928@tiehlicka.suse.cz>	<C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>	<4CEAA151.7050404@arndnet.de>	<20101123063200.GA23907@elte.hu>	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>	<20101122233654.117eef93.akpm@linux-foundation.org>	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>	<20101123075742.GA28714@elte.hu>	<20101123000232.e51b99b7.akpm@linux-foundation.org>	<20101123091756.GA22530@elte.hu>	<1290505290.3674.4.camel@jlt3.sipsolutions.net> <20101129150323.a03a09bf.akpm@linux-foundation.org>
In-Reply-To: <20101129150323.a03a09bf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/10 15:03, Andrew Morton wrote:
> On Tue, 23 Nov 2010 10:41:30 +0100
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
>> On Tue, 2010-11-23 at 09:17 +0000, Ingo Molnar wrote:
>>
>>> It fails to build on x86 64-bit allmodconfig:
>>
>> Let's not modify them to tristate then, too many ifdefs.
>>
>> johannes
>>
>>
>> Subject: leds: fix up dependencies
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> It's not useful to build LED triggers when
>> there's no LEDs that can be triggered by
>> them. Therefore, fix up the dependencies
>> so that this cannot happen, and fix a few
>> users that select triggers to depend on
>> LEDS_CLASS as well (there is also one user
>> that also selects LEDS_CLASS, which is OK).
> 
> Ingo, Randy: does this work for you?
> 

Yes, it passes all of my saved build failure cases.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> It's not useful to build LED triggers when there's no LEDs that can be
> triggered by them.  Therefore, fix up the dependencies so that this cannot
> happen, and fix a few users that select triggers to depend on LEDS_CLASS
> as well (there is also one user that also selects LEDS_CLASS, which is
> OK).
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnd Hannemann <arnd@arndnet.de>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Richard Purdie <rpurdie@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/leds/Kconfig      |   50 +++++++++++++++++++++++++++++-------
>  drivers/macintosh/Kconfig |    1 
>  net/mac80211/Kconfig      |    2 -
>  3 files changed, 43 insertions(+), 10 deletions(-)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
