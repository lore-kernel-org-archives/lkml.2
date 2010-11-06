Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0KFLye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:54:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36076 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab0KFLyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:54:33 -0400
Subject: Re: [PATCH] regulator: lock supply in regulator enable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
In-Reply-To: <4CD29C7D.4050500@stericsson.com>
References: <4CD2847B.1060009@stericsson.com>
	 <1288865910.3277.23.camel@odin>  <4CD28FA6.9030303@stericsson.com>
	 <1288869112.3277.25.camel@odin>  <4CD29C7D.4050500@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 11:54:28 +0000
Message-ID: <1289044468.3318.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 12:43 +0100, Mattias Wallin wrote:
> > Sorry, got a busy schedule atm. Can you give us your reasoning behind
> > why you think we need a lock here ?
> Yes, when we enter regulator_enable() we take the lock only for that specific regulator rdev->mutex
> and calls the locked function _regulator_enable().
> This locked function then checks if we have a supply and recursively calls the locked _regulator_enable() again but with the supply rdev as argument.
> The supply rdev regulator is however not locked at this stage, only the "original" supplied regulator is locked.
> So if we have two regulators with the same supply regulator trying to enable at approx. the same time they will both
> enter the _regulator_enable without locks and we could get a race condition.
> This would probably result in reference counting error and unbalanced regulator warnings.
> 
> In our system we make use the regulator hierarchy quite heavily.
> > 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

