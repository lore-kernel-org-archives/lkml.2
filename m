Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1GWKnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 06:43:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44301 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752608Ab1GWKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 06:43:36 -0400
Date: Sat, 23 Jul 2011 11:43:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        ashishj3 <ashish.jangam@kpitcummins.com>,
        Dajun <dajun.chen@diasemi.com>, sameo@openedhand.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Message-ID: <20110723104333.GA13883@opensource.wolfsonmicro.com>
References: <201107231150.31055.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107231150.31055.arnd@arndb.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 11:50:30AM +0200, Arnd Bergmann wrote:

> Yes, that makes sense. There are also cases where a mutex should really
> be a spinlock (which is by definition not interruptible), or vice
> versa. I don't know if this is one of them.

We would be using spinlocks except the underlying buses sleep waiting
for the hardware to complete the transfer - the operations are quick
enough from a user perspective but at the very low level we want the CPU
to be able to go off and do other things while they're happening.
