Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2G3PdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:33:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47881 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab2G3PdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:33:11 -0400
Date: Mon, 30 Jul 2012 16:33:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Add intermediate cast to uintptr_t
 before casting to pointer
Message-ID: <20120730153309.GK4468@opensource.wolfsonmicro.com>
References: <1343605633.11323.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343605633.11323.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 07:47:13AM +0800, Axel Lin wrote:

>  		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
> -				     (void *)best_val);
> +				     (void *)(uintptr_t)best_val);

This also looks problematic, you should never need to cast a pointer to
or from void.
