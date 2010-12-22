Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0LVN30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:29:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54112 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753020Ab0LVN3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:29:24 -0500
Date: Wed, 22 Dec 2010 13:29:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 4/6] MFD MAX8998/LP3974 Bufgix: accessing array out
 of bound.
Message-ID: <20101222132936.GE26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
 <1292998991-26968-5-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292998991-26968-5-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:23:09PM +0900, MyungJoo Ham wrote:

> The previous driver may access ldo_voltage_map[] out of its bound at
> probe function at line 790 (drivers/regulator/max8998.c). This patch
> allocates an entry for every regulator in order to avoid accessing
> out-of-bounds.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

for the fix but

>  	&buck4_voltage_map_desc,	/* BUCK4 */
> +	NULL,				/* EN32KHZ_AP */
> +	NULL,				/* EN32KHZ_CP */
> +	NULL,				/* ENVICHG */
> +	NULL,				/* ESAFEOUT1 */
> +	NULL,				/* ESAFEOUT2 */

it might be nicer to do this with a constant for the array size, or by
having the users check for ARRAY_SIZE().
