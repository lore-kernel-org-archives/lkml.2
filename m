Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1FCRFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:05:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47524 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1FCRFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110527201201.GA6645@ponder.secretlab.ca>
References: <20110523134815.fb87933a.randy.dunlap@oracle.com>
 <20110523224659.GB19533@opensource.wolfsonmicro.com> <20110523155343.2e68c265.randy.dunlap@oracle.com>
 <20110524000837.GA30515@opensource.wolfsonmicro.com> <4DDB082F.3010107@oracle.com>
 <20110524014959.GA27710@opensource.wolfsonmicro.com> <4DDB3AFF.9030006@oracle.com>
 <20110524075248.GB19734@sirena.org.uk> <20110527074552.GA907@ponder.secretlab.ca>
 <4DDFE391.2030507@oracle.com> <20110527201201.GA6645@ponder.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Jun 2011 11:04:52 -0600
X-Google-Sender-Auth: yI2D5kqklPZkg1UkGZJddVBNZrM
Message-ID: <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
Subject: Re: [PATCH] gpio: add GPIOF_ values regardless on kconfig settings
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 2:12 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, May 27, 2011 at 10:46:57AM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
>> is enabled by moving them to <linux/gpio.h>.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>
> Applied, thanks.

Hi Randy,

I ended up not pushing this one to Linus.  Turns out it causes other
breakage on other platforms that don't include include/linux/gpio.h.
Since I don't have confidence that I'll be able to find all the
offenders, I'm dropping it.  I recommend making any drivers that are
breaking on these symbols depend on GPIOLIB.  Platforms not using
gpiolib are strongly discouraged now anyways, and there only a handful
of files in drivers/ that reference GPIOF_*.

g.
