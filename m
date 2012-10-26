Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2JZF3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 01:29:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34240 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2JZF3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 01:29:07 -0400
MIME-Version: 1.0
In-Reply-To: <20121026042832.GB20205@linux-sh.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-28-git-send-email-keescook@chromium.org>
	<20121026042832.GB20205@linux-sh.org>
Date: Thu, 25 Oct 2012 22:29:05 -0700
X-Google-Sender-Auth: 90nANeMHolEYTCCZavSu4tO2x2E
Message-ID: <CAGXu5jJpN4dt96A04RHU_9Z8rU0L_4b11aP_wN7qATDHs9r=kw@mail.gmail.com>
Subject: Re: [PATCH 027/193] arch/sh: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 9:28 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Oct 23, 2012 at 01:01:40PM -0700, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>>
>> CC: Paul Mundt <lethal@linux-sh.org>
>> CC: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> While there are cases where it is largely superfluous, we also have
> plenty of cases in here that are genuinely experimental features and
> generally shouldn't be enabled unless someone is prepared for some
> hacking. We can of course replace this with an arch-specific option if
> needed, but I disagree with suddenly making experimental features
> suddenly appear to be anything other than what they are.

Yeah, things that really are experimental need something, but it
hasn't been meaningful to put them behind CONFIG_EXPERIMENTAL. Here's
the text from the first patch, which details possible approaches:

https://lkml.org/lkml/2012/10/23/878
This config item has not carried much meaning for a while now and is
almost always enabled by default (especially in distro builds). As agreed
during the Linux kernel summit, it should be removed. As a first step,
remove it from being listed, and default it to on. Once it has been
removed from all subsystem Kconfigs, it will be dropped entirely.

For items that really are experimental, maintainers should use "default
n", optionally include "(EXPERIMENTAL)" in the title, and add language to
the help text indicating why the item should be considered experimental.

For items that are dangerously experimental, the maintainer is encouraged
to follow the above title recommendation, add stronger language to the
help text, and optionally use (depending on the extent of the danger,
from least to most dangerous): printk(), add_taint(TAINT_WARN),
add_taint(TAINT_CRAP), WARN_ON(1), and CONFIG_BROKEN.


-Kees

-- 
Kees Cook
Chrome OS Security
