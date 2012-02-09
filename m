Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2BIF02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:26:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44372 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2BIF01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:26:27 -0500
MIME-Version: 1.0
In-Reply-To: <CACqU3MXdKti6J2ozx3mt3UHdhv1fyPredvT6zJGR+u_hNU70Cg@mail.gmail.com>
References: <20120207.091612.181444339.anemo@mba.ocn.ne.jp>
	<CACqU3MXdKti6J2ozx3mt3UHdhv1fyPredvT6zJGR+u_hNU70Cg@mail.gmail.com>
Date: Thu, 9 Feb 2012 00:26:25 -0500
Message-ID: <CACqU3MU6j0ed6C9QDfzuoH+2a-2hww2wrCsQXW-kUfK37iansQ@mail.gmail.com>
Subject: Re: kconfig: tristate choice with depender choice
From: Arnaud Lacombe <lacombar@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 9, 2012 at 12:08 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Mon, Feb 6, 2012 at 7:16 PM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
>> If a tristate choice has another choice dependers, kconfig produce
>> wrong value.
>>
>> Example:
>>
>> choice
>>        prompt "choice list AB"
>> config A
>>        tristate "a"
>> config B
>>        tristate "b"
>> endchoice
>> choice
>>        prompt "choice list CD"
>>        depends on A
>> config C
>>        bool "c"
>> config D
>>        bool "d"
>> endchoice
>>
>> kconfig outputs CONFIG_A=m from defconfig with CONFIG_A=y.
>>
>> This happens if the choice list CD depends on A.
>> Also, if defconfig contains CONFIG_A=y and "# CONFIG_B is not set",
>> output is correct.
>>
> confirmed.
>
actually, not that much. Your reduced testcase is missing a MODULES
symbol to have modules enabled and have them show up in the final
`.config'. If you add:

config MODULES
  boolean
  default y

then you end up with CONFIG_A=m in the `.config'.

Now, I may have missed something.

Do you have a situation where a MODULES symbol is present, enabled,
but CONFIG_A=y still appear from CONFIG_A=m in the defconfig ?

Thanks,
 - Arnaud

>> I found commit a64b44ea ("kconfig: fix tristate choice with minimal
>> config"), but this problem still exists on v3.3-rc1.  More fix is
>> needed for choice with dependers?
>>
> it would seem so.
>
>  - Arnaud
