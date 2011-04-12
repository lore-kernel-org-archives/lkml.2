Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab1DLWsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:48:45 -0400
Received: from void.printf.net ([89.145.121.20]:60765 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1DLWso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:48:44 -0400
From: Chris Ball <cjb@laptop.org>
To: Cyril Hrubis <metan@ucw.cz>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        linux-mmc@vger.kernel.org
Subject: Re: zaurus: mmcblk0: error -110
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
	<m3aafvz30t.fsf@pullcord.laptop.org>
	<20110412193944.GC2665@atrey.karlin.mff.cuni.cz>
	<m3oc4bxne1.fsf@pullcord.laptop.org>
	<20110412205421.GD2665@atrey.karlin.mff.cuni.cz>
	<m3fwpnxj1w.fsf@pullcord.laptop.org>
	<20110412224333.GA22640@atrey.karlin.mff.cuni.cz>
Date: Tue, 12 Apr 2011 18:53:29 -0400
In-Reply-To: <20110412224333.GA22640@atrey.karlin.mff.cuni.cz> (Cyril Hrubis's
	message of "Wed, 13 Apr 2011 00:43:33 +0200")
Message-ID: <m339lnxes6.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 12 2011, Cyril Hrubis wrote:
>> > mmc0: error -95 whilst initialising SD card
>> 
>> That's interesting.  Would you mind trying to bisect?  (Knowing whether
>> 2.6.38 final does it, for example, would be very helpful.)
>
> It may need one or two tries on 2.6.38 but it's there too.
>
>> There aren't many -EOPNOTSUPP returns in the stack.  I see:
>> 
>> card/block.c: mmc_blk_issue_secdiscard_rq and mmc_blk_issue_discard_rq
>> card/core.c: mmc_erase
>> core/sd_ops.c: mmc_app_cmd
>> 
>> Mind doing some instrumentation to figure out which it is?
>
> Fails in the mmc_app_cmd.

Okay.  mmc_app_cmd() hasn't changed for years, so I'm afraid I don't
have any strong leads for you -- further bisection (you're pretty
sure this is a regression?) would be very useful.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
