Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab0EaJ6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:58:35 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37977 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab0EaJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UfmMDeXGEMw9t5UwKhYTjmT1QvKRvg3WTGw9STpxMu4q78CYPT/y+dT+wJyK+THTB7
         gdszV3Z+X0W3W4y7F4Oyndvs53AfSvGfJlJadF3W1v10e9GX7JfTRYMhGDhaQWN86bYw
         7BMvxPEvZVz/KaQCvrftMHksUKIFemHd5i++o=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1005311905520.469@nippy.intranet>
References: <alpine.OSX.2.00.1004171258330.358@localhost>
	<20100421.163041.158540277.davem@davemloft.net>
	<alpine.OSX.2.00.1005290255580.691@localhost>
	<20100531.001947.193703044.davem@davemloft.net>
	<alpine.LNX.2.00.1005311905520.469@nippy.intranet>
Date: Mon, 31 May 2010 11:58:30 +0200
X-Google-Sender-Auth: cG5ITo03NY8zPcV5UTSyyDrGTQs
Message-ID: <AANLkTilkooBglbk33yDHmk8c_ZdlamOW8FVvuvjQaNsF@mail.gmail.com>
Subject: Re: [PATCH] mac8390: change an error return code and some cleanup, 
	take 4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: fthain@telegraphics.com.au
Cc: David Miller <davem@davemloft.net>, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:21,  <fthain@telegraphics.com.au> wrote:
> On Mon, 31 May 2010, David Miller wrote:
>> This is getting tiring Finn.
>
> I agree. My patch addresses all of the criticism of the earlier
> submissions.
>
> To make it plain: there are 25 files or so that use ei_debug. Three of
> those that now have the KERN_DEBUG printk's suppresed by the DEBUG macro
> only do so as an apparently unintended side effect of a commit that claims
> to "implement dynmic debug infrastructure". (Go figure.)
>
> http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=dd0fab5b940c0b65f26ac5b01485bac1f690ace6
>
> Your suggestion to use pr_debug is invoking compile time infrastructure
> (the DEBUG macro), so it is not in the spirit of this commit, and it is
> not relevant to any criticism from you or Joe of the earlier submissions.
>
> Please apply the patch.

`pr_debug()' indeed now may generate code if DEBUG is not defined,
i.e. if CONFIG_DYNAMIC_DEBUG is enabled.
This is intented for debug infrastructure the user may want to enable later.

If you want the old behavior, you can use `pr_devel()' instead, which
only generates code if DEBUG is defined.
This is intended for debug infrastructure for developers only.

However, you used `printk(KERN_DEBUG pr_fmt()...)`, which always generates code.
I'm still not 100% sure that was intentional?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
