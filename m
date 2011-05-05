Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1EEP1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:27:22 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51066 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1EEP1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=NushKYPZX6eSnP65lRQSsWp2LKb1lGGFOulB9Dd7Bb5q8VDZVBtqgOP++z3VK36M2u
         HwkyVTWbvj1bBayFAidMuWGtO0r7cfBXJAa218PgavCxZzTUL34CPSOKP/dTx+HkoYsD
         pDqxteEuRrX8Z3Wlc5PFHyqowYw1CDuOS4ljs=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110503191525.GE11574@pengutronix.de>
References: <1304440079.16287.7.camel@phoenix> <20110503191525.GE11574@pengutronix.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 5 May 2011 23:26:59 +0800
Message-ID: <BANLkTi=hMU0cdiGAaj5oqKvPQD1T=6soYA@mail.gmail.com>
Subject: Re: [RFC][PATCH] mfd: mc13xxx-core: put mutex lock down to
 mc13xxx_reg_rmw function
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I havn't looked deeply, but I guess this can have unwanted side effects
> here. Before you had:
>
>        lock()
>        do(something)
>        do(something, else, that, needs, rmw)
>        unlock()
>
> and you introduced an unlock()/lock() between these two do()s.
>
Indeed, you are right. I cannot change it this way.

> I'm not convinced this change is good, though I agree that
>
>        lock()
>        rmw(...)
>        unlock()
>
> looks ugly, but imho this can better be fixed by adding a wrapper for
> that sequence if you really want.
>
> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
