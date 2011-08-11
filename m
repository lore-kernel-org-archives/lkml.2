Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1HKRVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:21:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:57903 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1HKRVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:21:11 -0400
Message-ID: <4E440F6D.7020009@windriver.com>
Date: Thu, 11 Aug 2011 13:20:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, <sfr@canb.auug.org.au>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com> <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com> <20110802183019.GB8393@windriver.com> <CAMjpGUcOagn-o_mETLDr-=pa-3sxq_iDjF=A8OGhdJg5+9ewpA@mail.gmail.com> <4E42D769.8030704@windriver.com> <CAMjpGUcTMwYs99Nu02u+Sbg99RuJvRDpjvY6ChDLUEASf1wUrA@mail.gmail.com> <4E43D4AD.6080702@windriver.com> <CAMjpGUch3O_DWKv39A_H91bU5ypSxSgHjSVX8WYDnGxKVBPZLQ@mail.gmail.com>
In-Reply-To: <CAMjpGUch3O_DWKv39A_H91bU5ypSxSgHjSVX8WYDnGxKVBPZLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-11 01:15 PM, Mike Frysinger wrote:
> On Thu, Aug 11, 2011 at 09:10, Paul Gortmaker wrote:
>> On 11-08-11 12:34 AM, Mike Frysinger wrote:
>>> On Wed, Aug 10, 2011 at 15:09, Paul Gortmaker wrote:
>>>> Have you thought about getting at least one blackfin defconfig in
>>>> the linux-next build coverage?  Gives you a better chance of
>>>> having people see when they've broken it.
>>>
>>> all of the blackfin defconfigs get tested nightly in linux-next by an
>>> ADI build machine.  i just didnt have a chance to review the logs as i
>>> was traveling.
>>
>> That is good, but as you've noted, it isn't something that anyone
>> else can see when they are combing the normal linux-next build
>> results below looking to see if they broke anything.
>>
>> http://kisskb.ellerman.id.au/kisskb/branch/9/
> 
> ive never heard of this site before, and there doesnt appear to be any
> documentation on that site about it
> -mike

It is mentioned in the boilerplate text that Stephen puts in his
daily linux-next emails (copied below).  Note the text about
"always open to add more builds" -- that is what I had in mind
when suggesting you get blackfin added to -next coverage builds.

P.

--------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
and sparc64 defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 199 trees (counting Linus' and 28 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
