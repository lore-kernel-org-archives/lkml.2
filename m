Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab1EESeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:34:20 -0400
Received: from 75.98.165.80.static.a2webhosting.com ([75.98.165.80]:58319 "EHLO
	greenroomsoftware.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab1EESeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:34:19 -0400
Message-ID: <4DC2ED9F.5080601@greenroomsoftware.com>
Date: Thu, 05 May 2011 11:34:07 -0700
From: Robert Gordon <robert@greenroomsoftware.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nuno Subtil <subtil@gmail.com>
CC: maximilian attems <max@stro.at>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
References: <1304488750-13606-1-git-send-email-subtil@gmail.com> <20110504204807.GB13293@sepie.suse.cz> <20110505090728.GC30678@vostochny.stro.at> <4DC2C568.9090803@greenroomsoftware.com> <BANLkTinjBun=TzjveEiJsEJYKH_+NRCP7Q@mail.gmail.com> <4DC2EB2B.1050203@greenroomsoftware.com>
In-Reply-To: <4DC2EB2B.1050203@greenroomsoftware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s60.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - greenroomsoftware.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/11 11:23 AM, Robert Gordon wrote:
> On 5/5/11 10:10 AM, Nuno Subtil wrote:
>> This patch is not meant to fix that case, only the case where
>> KBUILD_DEBARCH is used.
>>
>> KBUILD_DEBARCH seems to be meant to be used as an override for what
>> Debian wants to see as the target architecture. Arguably, the right
>> thing to do here might be to do the same arch detection sequence
>> that's done in create_package(), which looks at UTS_MACHINE first and
>> the KBUILD_DEBARCH override after that (though I'm not entirely sure).
>>
>> This patch only adds the KBUILD_DEBARCH override, but that is still
>> better than the current situation. I can easily get the rest in later
>> if needed.
>>
>> Nuno
>>
>> On Thu, May 5, 2011 at 08:42, Robert Gordon
>> <robert@greenroomsoftware.com> wrote:
>>> On 05/05/2011 02:07 AM, maximilian attems wrote:
>>>> On Wed, May 04, 2011 at 10:48:07PM +0200, Michal Marek wrote:
>>>>> Adding Maks to CC.
>>>> thanks, this one looks, good please disguard the other patch.
>>>>
>>>>> On Tue, May 03, 2011 at 10:59:10PM -0700, Nuno Subtil wrote:
>>>>>> When generating the header package, scripts/package/builddeb was
>>>>>> inferring the
>>>>>> target architecture by looking at the output of dpkg
>>>>>> --print-architecture. This
>>>>>> allows KBUILD_DEBARCH to override that.
>>>>>>
>>>>>> Signed-off-by: Nuno Subtil<subtil@gmail.com>
>>>> Acked-by: maximilian attems<max@stro.at>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-kbuild" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>> Greetings,
>>>
>>> Compile breaks when using the following command:
>>> fakeroot make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- deb-pkg
>>>
>>> With 'set -x' in scripts/package/builddeb, the relevant output is:
>>> + '[' -n '' ']'
>>> ++ dpkg --print-architecture
>>> + arch=i386
>>> This indicates that KBUILD_DEBARCH is not set.
>>>
>>> The debian/control file is written with the following section:
>>> Package: linux-headers-2.6.39-rc5+
>>> Provides: linux-headers, linux-headers-2.6
>>> Architecture: i386
>>> Description: Linux kernel headers for 2.6.39-rc5+ on i386
>>> This package provides kernel header files for 2.6.39-rc5+ on i386
>>>
>>> This produces the following error output:
>>> + forcearch=-DArchitecture=armel
>>> + dpkg-gencontrol -isp -DArchitecture=armel
>>> -plinux-headers-2.6.39-rc5+ -P/opt/kernel-linus/linux-2.6/debian/hdrtmp
>>> dpkg-gencontrol: error: current host architecture 'armel' does not
>>> appear in package's architecture list (i386)
>>>
>>> Regards,
>>> Robert
>>>
>>>
> Nuno,
> Thanks for the response. I am very new at this process, but I am trying
> to learn. Yesterday, I submitted a patch that was intended to address
> the same issue that you have addressed. I did what you are suggesting by
> mimicking what is done in create_package(), but leaving i386/x86_64
> untouched. Here is the subject of the patch I sent:
>
> [PATCH] kbuild, deb-pkg: set host machine $arch correctly when
> cross-compiling or not
>
> Please advise if I should resend.
>
> Regards,
> Robert
>
> -- *
> *
>

Apologies, resending because messages were rejected by the mailing lists 
(probably due to html) - Robert

-- 
