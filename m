Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2ENQa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:30:28 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:32083 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab2ENQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:30:27 -0400
Message-ID: <1337013022.2476.17.camel@lorien2>
Subject: Re: [PATCH 0/11] Merge ramoops and persistent_ram, generic pstore
 RAM backend
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: shuahkhan@gmail.com, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
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
        Thomas Meyer <thomas@m3y3r.de>, tony.luck@intel.com
Date: Mon, 14 May 2012 10:30:22 -0600
In-Reply-To: <20120514155846.GA19538@kroah.com>
References: <20120512001506.GA8653@lizard>
	 <20120514155846.GA19538@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 08:58 -0700, Greg Kroah-Hartman wrote:
> On Fri, May 11, 2012 at 05:15:06PM -0700, Anton Vorontsov wrote:
> > Hi all,
> > 
> > There are currently two competing debug facilities to store kernel
> > messages in a persistent storage: a generic pstore and Google's
> > persistent_ram. Not so long ago (https://lkml.org/lkml/2012/3/8/252),
> > it was decided that we should fix this situation.
> > 
> > Recently ramoops has switched to pstore, which basically means that
> > it became a RAM backend for the pstore framework.
> > 
> > persistent_ram+ram_console and ramoops+pstore have almost the same
> > features, except:
> > 
> > 1. Ramoops doesn't support ECC. Having ECC is useful when a hardware
> >    reset was used to bring the machine back to life (i.e. a watchdog
> >    triggered). In such cases, RAM may be somewhat corrupt, but
> >    usually it is restorable.
> > 
> > 2. Pstore doesn't support logging kernel messages in run-time, it only
> >    dumps dmesg when kernel oopses/panics. This makes pstore useless for
> >    debugging hangs caused by HW issues or improper use of HW (e.g.
> >    weird device inserted -> driver tried to write a reserved bits ->
> >    SoC hanged. In that case we don't get any messages in the pstore.
> > 
> > These patches solve the first issue, plus move things to their
> > proper places. Patches that will fix the second issue are pending.
> 
> I've applied the first 7 patches, as they were localized to the
> drivers/staging/android/ directory, but in order for me to apply the
> rest, I need acks from the respective subsystem maintainers.
> 
> pstore developers, what do you say about these changes, are you ok with
> them?

Good to see this work get done. Anton beat me to it. :) I have been
talking to pstore developers (Tony Luck) and ramoops maintainers (Kees
Cook) about this re-architecture work since I first floated this idea on
ce-android mailing list. I have been working on this rec-architecture
focusing on the second feature "Pstore doesn't support logging kernel
messages in run-time" and didn't get to ECC even though it is on my
feature list to do bring ramconsole features into ramoops.

Anton! Is it safe to assume you are planning to cover the second feature
as well, in which case I can drop my plans to get this work done.

-- Shuah
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


