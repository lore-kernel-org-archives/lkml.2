Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1ECPVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:21:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40189 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751863Ab1ECPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:21:42 -0400
Date: Tue, 3 May 2011 16:21:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Remove mc13xxx_unlock in regulator_register
 failure path
Message-ID: <20110503152139.GU1762@opensource.wolfsonmicro.com>
References: <1304435704.2591.18.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304435704.2591.18.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:15:04PM +0800, Axel Lin wrote:
> We do not hold the mutex_lock of struct mc13xxx while calling regulator_register,
> Thus remove mc13xxx_unlock in regulator_register failure path.

This feels painful, we shouldn't have to be faffing about with the lock
like this for basic I/O operations.  It feels like we should be pushing
the lock down into the register access functions - looking at the driver
I can't really see any reason why all this stuff is being done by hand,
especially when we've got explicit read/modify/write bitmask operations.
