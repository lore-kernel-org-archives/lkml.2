Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601Ab1ETKXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:23:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53074 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754472Ab1ETKW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:22:59 -0400
Date: Fri, 20 May 2011 11:23:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH v2] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
Message-ID: <20110520102302.GD22711@opensource.wolfsonmicro.com>
References: <1305851766.2244.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305851766.2244.2.camel@phoenix>
X-Cookie: You fill a much-needed gap.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 08:36:06AM +0800, Axel Lin wrote:

> -	return ret - rdev->constraints->uV_offset;
> +	return ret < 0 ? ret : ret - rdev->constraints->uV_offset;

Please don't use the ternery operator, I find it does nothing for
legibility.
