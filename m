Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2JIGeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:34:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38092 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440Ab2JIGeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:34:11 -0400
Date: Tue, 9 Oct 2012 15:33:53 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: andrey.smrinov@convergeddevices.net, hverkuil@xs4all.nl,
        mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz,
        tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] Add the main bulk of core driver for SI476x code
Message-ID: <20121009063349.GN8237@opensource.wolfsonmicro.com>
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net>
 <1349488502-11293-3-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349488502-11293-3-git-send-email-andrey.smirnov@convergeddevices.net>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 06:54:58PM -0700, Andrey Smirnov wrote:

> +			err = regulator_enable(core->supplies.va);
> +			if (err < 0)
> +				break;
> +			
> +			err = regulator_enable(core->supplies.vio2);
> +			if (err < 0)
> +				goto disable_va;
> +
> +			err = regulator_enable(core->supplies.vd);
> +			if (err < 0)
> +				goto disable_vio2;
> +			
> +			err = regulator_enable(core->supplies.vio1);
> +			if (err < 0)
> +				goto disable_vd;

If the sequencing is critical here you should have comments explaining
what the requirement is, otherwise this looks like a prime candidate
for conversion to regulator_bulk_enable() (and similarly for all the
other regulator usage, it appears that all the regulators are worked
with in a bulk fashion).
