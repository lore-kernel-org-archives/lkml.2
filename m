Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2DVWD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 18:03:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60932 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2DVWD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:58 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <201204222032.48694.arnd@arndb.de>
References: <4F8D9037.9010401@atmel.com>
	<201204222032.48694.arnd@arndb.de>
Date: Sun, 22 Apr 2012 15:03:57 -0700
Message-ID: <CAOesGMg4fJD9ojem_Z2ZZTswK10TwNMtBMncPYhQS9ozmPfqbg@mail.gmail.com>
Subject: Re: [GIT PULL] at91: fist cleanup branch for 3.5
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 1:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 17 April 2012, Nicolas Ferre wrote:
>> Arnd, Olof,
>>
>> The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:
>>
>>   Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-3.5-cleanup
>>
>> for you to fetch changes up to 39ecc143b4c1f3d42e8300e7f5274681b99f95c2:
>>
>>   ARM: at91: add defconfig for device tree (2012-04-17 14:47:22 +0200)
>>
>> ----------------------------------------------------------------
>> First batch of AT91 cleanup for 3.5 kernel.
>> - The biggest improvement of this series is the ability to compile several
>>   AT91 SoCs in one kernel image.
>>   For now on it's limited to the DT-enabled boards but we can compile all
>>   the core together.
>> - The Kconfig series is stacked before other patches as it is simple and
>>   non-intrusive. Its goal is to remove too restrictive dependencies on
>>   SoC names. This will allow to add support for newer SoC seamlessly.
>> - Some very "cosmetic" Kconfig changes are also added (entry names,
>>   comments, etc.).
>
> Pulled into the next/cleanup branch, and also pulled the MAINTAINERS
> update into the next/maintainers branch.
>
> Olof, this is the first pull from a tag I've done, and I think we
> should decide on a method to show these pulls in the log. I've
> set the at91/cleanup branch to the version that Nicolas sent,
> without the merge changeset that is normally generated when you
> pull from a tag. For next/cleanup branch, I've pulled directly from
> the tag and edited the commit message a bit. Do you think that's good
> or do you know a better way to handle these?

Short version:

That sounds like a good way to handle it, and it's similar to how I
did things for the last cycle.

Long version:

There, I had this workflow:

* git fetch <url+branch from pull request>
* tig FETCH_HEAD   (look at contents, sanity check, etc: If something
looks wrong there's no merge to undo)
* git checkout -b subarch/topic FETCH_HEAD     to create the pulled-in
topic branch
* git checkout next/topic
* git pull --log <url+branch from pull request>    to get the original
URL in the merge commit

Then the usual steps to get it into for-next and added to the contents file.

That way we do get the --log in the next/ branch as well as the tag
message, but only one merge changeset. It also has the benefit of
making it trivial to see when things have been merged with mainline
which branches can be pruned and not.

The only thing missing from that workflow is the authenticity of the
subarch/topic branch once it's done, in case there is tinkering with
the arm-soc repo by some third party. I don't think that's a big risk
since we tend to diff the for-next contents before and after a
rebuild, so any delta in file contents will be caught. Since each
branch is documented in arm-soc-for-next-contents, we should have all
bases covered there.

I guess we could tag every subarch/topic tip as well, but it'll get
pretty noisy with all them in the main repo. We have the option of
pushing those to a separate repo instead of the main arm-soc.git if we
wanted though.


-Olof
