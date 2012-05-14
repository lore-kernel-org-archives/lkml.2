Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2ENP6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:58:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49764 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2ENP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:58:51 -0400
Date: Mon, 14 May 2012 08:58:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sergiu Iordache <sergiu@chromium.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 0/11] Merge ramoops and persistent_ram, generic pstore
 RAM backend
Message-ID: <20120514155846.GA19538@kroah.com>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 05:15:06PM -0700, Anton Vorontsov wrote:
> Hi all,
> 
> There are currently two competing debug facilities to store kernel
> messages in a persistent storage: a generic pstore and Google's
> persistent_ram. Not so long ago (https://lkml.org/lkml/2012/3/8/252),
> it was decided that we should fix this situation.
> 
> Recently ramoops has switched to pstore, which basically means that
> it became a RAM backend for the pstore framework.
> 
> persistent_ram+ram_console and ramoops+pstore have almost the same
> features, except:
> 
> 1. Ramoops doesn't support ECC. Having ECC is useful when a hardware
>    reset was used to bring the machine back to life (i.e. a watchdog
>    triggered). In such cases, RAM may be somewhat corrupt, but
>    usually it is restorable.
> 
> 2. Pstore doesn't support logging kernel messages in run-time, it only
>    dumps dmesg when kernel oopses/panics. This makes pstore useless for
>    debugging hangs caused by HW issues or improper use of HW (e.g.
>    weird device inserted -> driver tried to write a reserved bits ->
>    SoC hanged. In that case we don't get any messages in the pstore.
> 
> These patches solve the first issue, plus move things to their
> proper places. Patches that will fix the second issue are pending.

I've applied the first 7 patches, as they were localized to the
drivers/staging/android/ directory, but in order for me to apply the
rest, I need acks from the respective subsystem maintainers.

pstore developers, what do you say about these changes, are you ok with
them?

thanks,

greg k-h
