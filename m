Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223Ab2KVT35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:29:57 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64301 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124Ab2KVT3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <20121121204324.21126.99677@nucleus>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
	<CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
	<20121121204324.21126.99677@nucleus>
Date: Thu, 22 Nov 2012 09:04:18 +0530
Message-ID: <CAKohpo=fNxADu4z9y6R7XBJEvr7ksOOY0LqZ9MfHnBgmDFgBvg@mail.gmail.com>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 02:13, Mike Turquette <mturquette@ti.com> wrote:
> HAVE_CLK logically wraps HAVE_CLK_PREPARE.  There is no point in
> selecting HAVE_CLK_PREPARE without HAVE_CLK.
>
> Looking through the code I see that this used to be the case.  Commit
> 93abe8e "clk: add non CONFIG_HAVE_CLK routines" moved the
> clk_(un)prepare declarations outside of #ifdef CONFIG_HAVE_CLK.  That
> commit was authored by you.  Can you elaborate on why that aspect of the
> patch was needed?

Haha... Caught red handed :(

Before this commit, nothing was enclosed within CONFIG_HAVE_CLK and
this patch only introduced it. I am not really sure, why i kept
prepare/unprepare
out of it though :(

Maybe because some platform at that time is using it directly, without
CONFIG_HAVE_CLK. Not sure.

--
viresh
