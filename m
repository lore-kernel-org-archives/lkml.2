Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab0FKLVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:21:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55270 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab0FKLVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:21:07 -0400
Date: Fri, 11 Jun 2010 12:21:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] input: STMPE811 touch controller support
Message-ID: <20100611112102.GE12436@sirena.org.uk>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de> <1276251195-22981-4-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276251195-22981-4-git-send-email-l.fu@pengutronix.de>
X-Cookie: Postage will be paid by addressee.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:13:15PM +0200, Luotao Fu wrote:

> +/*
> + * reference source:
> + *
> + * Set ref_sel = 0 for internal reference
> + *     ref_sel = 1 for external reference
> + */
> +static int ref_sel;
> +module_param(ref_sel, int, 0444);
> +MODULE_PARM_DESC(ref_sel,
> +	"Set ADC reference source. Default is 0 (internal reference)");

This looks like something that ought to be configured via platform data
since the value that should be used is going to be determined by the
board schematic.  Similar comments apply to most of the other module
parameters, though in some cases sysfs files might be more appropriate
as well, or in addition.
