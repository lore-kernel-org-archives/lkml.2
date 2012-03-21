Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031273Ab2CUOry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:47:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54765 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965179Ab2CUOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:47:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120321151357.53fb86e4@endymion.delvare>
References: <1332328201-21191-1-git-send-email-amit.kachhap@linaro.org>
	<20120321151357.53fb86e4@endymion.delvare>
Date: Wed, 21 Mar 2012 10:47:52 -0400
Message-ID: <CACLa4pts46gZmx=cGWF9UuHh-VpeoG9e2MmJR=xTn7sFxiFyjw@mail.gmail.com>
Subject: Re: [PATCH] thermal: Fix for setting the thermal zone mode to enable/disable
From: Eric Paris <eparis@parisplace.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 10:13 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Wed, 21 Mar 2012 16:40:01 +0530, Amit Daniel Kachhap wrote:
>> Basically without this patch changing the mode of thermal zone
>> is not possible as wrong string size is passed to strncmp.
>
> Actually it is possible,
> $ echo -n disabled > mode
> works fine. But it fails without the -n, your patch would fix that.
>
> Acked-by: Jean Delvare <khali@linux-fr.org>
>
> Note that a quick grep suggests that drivers/misc/ad525x_dpot.c,
> security/selinux/hooks.c and arch/m68k/sun3/prom/console.c suffer from
> the same issue, if you want to fix them too.

I do see that we use sizeof() for strings in the selinux code, but I
don't see a place that it is a bug.  If you see a bug let me know and
I'd be happy to fix it!

-Eric
