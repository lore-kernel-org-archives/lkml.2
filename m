Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1HYTPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:15:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40518 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1HYTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:15:14 -0400
Date: Thu, 25 Aug 2011 20:15:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]arm: nwfpe: '&pointer[0]' to 'pointer' fix
Message-ID: <20110825191501.GA4488@n2100.arm.linux.org.uk>
References: <20110825191143.GA3149@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825191143.GA3149@maxin>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:11:43PM +0300, Maxin B. John wrote:
> '&pointer[0]' to 'pointer' fix in arch/arm/nwfpe/fpa11_cpdt.c 

Your reason being?

>  #ifdef __ARMEB__
> -	get_user(p[0], &pMem[0]);	/* sign & exponent */
> +	get_user(p[0], pMem);	/* sign & exponent */
>  	get_user(p[1], &pMem[1]);

You may notice the original code has some consistency.  Your replacement
is less consistent.  If you wish to make this change, it should change to:

	get_user(p[0], pMem + 0);
	get_user(p[1], pMem + 1);

to maintain consistency.
