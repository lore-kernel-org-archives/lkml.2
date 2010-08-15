Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814Ab0HOSQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 14:16:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761Ab0HOSQm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 14:16:42 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
References: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Aug 2010 11:15:51 -0700
Message-ID: <AANLkTi=vngT_5XYz1=3P6GjExFNtCVCdBMhaz4Sc4oEk@mail.gmail.com>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
To: sedat.dilek@gmail.com, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: len.brown@intel.com, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 3:41 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> I pulled in release GIT-branch on top of 2.6.35-git16 (commit
> 5d7cb157025b3b4852f38e6e5e97d06ef12c1d78)
>
>   $ git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> release
>
> Unfortunately, the build breaks:
>
> [ build.log ]
> drivers/acpi/power.c: In function ‘acpi_power_off_device’:
> drivers/acpi/power.c:252: error: ‘ref’ undeclared (first use in this function)

What the heck is going on? That thing cannot have been tested AT ALL.
It comes from commit cfa806f05980 ("gcc-4.6: ACPI: fix unused but set
variables in ACPI"), and there is no way that code has ever been
compiled. There's no conditional compilation (except for not enabling
ACPI at all), and the declaration of 'ref' that the commit removes is
followed just a few lines later by the use.

So WTF?

I can merge this and fix it up, but I'm not going to. This thing
should never have been sent to me. It clearly had no testing at all. I
even looked at whether it could _possibly_ be some kind of odd "patch
applied with fuzz at the wrong place" issue, but that looks impossible
too (not to mention _still_ not being an excuse for not even trying to
compile the thing).

I understand when people don't notice compile errors that don't happen
for them (due to being architecture- or configuration-specific), but I
really don't see how that could _ever_ have been the case here.

I see Andrew in the sign-off chain, which surprises me. Maybe he just
passed on the patch blindly. But seriously, what the _hell_ is going
on here?

                              Linus
