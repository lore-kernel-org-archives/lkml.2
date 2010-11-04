Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0KDRrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:47:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59683 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0KDRrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X2vbJK+iHTg3d8F4Q1qqeXkrYG1hZ2nbf3FNo98NbSVzpfjUuxEZGdM659lrRcoe+W
         LeBzz/8T5F+on3puMxIL2bH6I+QprC1NIAOwf8H1mLniPsdb2CmZkTjg3/MzEaVAJlco
         UQzdIuka7Mza1+t7+39J41MrbVbp1bwV5bMY4=
Date: Thu, 4 Nov 2010 20:47:46 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
Message-ID: <20101104174746.GA16349@oksana.dev.rtsoft.ru>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
 <20101021162617.GA10447@oksana.dev.rtsoft.ru>
 <4CC07CB4.9060108@metafoo.de>
 <E88A1D35AF5437468E5B14C7C4BA61C702D3E13FB3@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E88A1D35AF5437468E5B14C7C4BA61C702D3E13FB3@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 02:17:41PM -0700, Rhyland Klein wrote:
[...]
> > Hm... I guess it can be, but on the other hand most platform bus chargers
> > type
> > devices can be, because the pda_power driver is keep pretty generic with
> > custom init,
> > status and exit callbacks.
> > 
> > - Lars
> 
> I didn't see any more discussion on this. Is the plan to integrate
> the gpio-charger driver as is or to instead try to integrate support
> for this into pda_power?

Sorry for the delayed response, and thanks for the pings! ;-)

The main thing I'm afraid of is duplication. I.e. someday you
will want debouncing (include/linux/pda_power.h's wait_for_status,
wait_for_charger parameters) support, regulators support etc.

And your gpio driver will look very similar to pda_power.

So I'd vote for adding the GPIO functionality to pda_power, and
refactoring it if needed.

Though, if there are strong objections against this idea, I
can merge the GPIO driver, and let's see how things will evolve.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
