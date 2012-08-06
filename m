Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2HFL4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:56:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55798 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756006Ab2HFL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:56:35 -0400
Date: Mon, 6 Aug 2012 12:56:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: regulator: Policy for setting current limits
Message-ID: <20120806115632.GB16861@opensource.wolfsonmicro.com>
References: <201208060127.57074.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201208060127.57074.heiko@sntech.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 01:27:56AM +0200, Heiko Stübner wrote:

> 500). Therefore if 500mA are the upper limit but the regulator also supports 
> lower values, these lower values always get selected (100mA in my case).
> In contrast pda_power sets the target current as both lower and upper limit.

This isn't good, it means that the regulator has to be able to deliver
exactly the limit requested.

> (a) let the gpio-regulator select the max current (in contrast to the minimum 
> voltage)
> (b) change gpio-vbus to also use the target current as min and max value
> (c) something else

Regulators should be tending to the maximum in the available range and
consumers should specify the widest range possible so both a and b.
