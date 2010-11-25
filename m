Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0KYRnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:43:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65055 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0KYRnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fX9MkPlPAWEF2zlFS8Zzwm4R2Ss3l63rPoAes1xMWk6Uk3vLGbe6x6d/rIGqSWBfm3
         nJ1FJ49+oVgzohOtnvvks8hgUQTay301xRfld6GesOb+m3HAXkGw3NQnNe0VkuVoBBWT
         vucTn7rNttcVEXSpFYY38/W95I1QbqfW+rhBw=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=io3tsuL8Hd2a0y8PyBYYAzb-gkJo1GfmpcF+L@mail.gmail.com>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>
	<AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
	<20101122135715.121b5eb7.sfr@canb.auug.org.au>
	<AANLkTi=io3tsuL8Hd2a0y8PyBYYAzb-gkJo1GfmpcF+L@mail.gmail.com>
Date: Thu, 25 Nov 2010 17:43:11 +0000
X-Google-Sender-Auth: AnFPAQWKX6NRzJBhvf8iTYN30Ig
Message-ID: <AANLkTi=eTvdfPjgd0pGVmBx6zCB8yL3qNVq0MR1wH88b@mail.gmail.com>
Subject: Re: [PATCH] Revert "kconfig: Temporarily disable dependency warnings"
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        randy.dunlap@oracle.com, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2010 17:16, Arnaud Lacombe <lacombar@gmail.com> wrote:
> On Sun, Nov 21, 2010 at 9:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> On Sun, 21 Nov 2010 20:58:54 -0500 Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> There is 2 patches which fixes that by adding to the kconfig language
>>> a "visible" property to menus, 1 revert of "another" solution (which
>>> works but does not scale) and 2 patch which makes usage of the new
>>> property. Ack-ed and complemented by Mauro, but still waiting
>>> review/blessing by Michal.
>>>
>>> The core change is available here: https://patchwork.kernel.org/patch/306412/
>>>
>>> Alternatively, if you don't care about the menu structure, Randy
>>> proposed a one-liner.
>>
>> OK, good to know it is being worked on.  Thanks.
>>
> FYI, I withdrawn the patches and ask for them not to be merged[0], as
> there is a clear lack of interest to see this issue resolved.
>
> Mauro, may I ask you to remove my patches from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
> kconfig_fixes

I still think the patches are useful. The fact that you didn't get any
comments from Michal doesn't mean that they are a bad idea, just lack
of time on the kbuild maintainer's side. It may have been a better
idea to cc LKML as well when you posted them (I for one don't follow
the kbuild list).

As for waiting times, I had patches taking even two years to get
merged. And my kbuild patch which actually introduced such warnings
had been around for nearly a year.

Now, commenting on your patches, you added a new statement, 'visible
if...' for menus. Can we not change it to something like:

-menu "I2C Algorithms"
-       depends on !I2C_HELPER_AUTO
+menu "I2C Algorithms" if !I2C_HELPER_AUTO

-- 
Catalin
