Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2I0NtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:49:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35123 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab2I0NtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:49:22 -0400
Date: Thu, 27 Sep 2012 14:49:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out
 common code
Message-ID: <20120927134919.GW4428@opensource.wolfsonmicro.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
 <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com>
 <20120925192048.GA17038@sirena.org.uk>
 <20120926145615.GJ10147@mail.gnudd.com>
 <20120926150429.GQ4428@opensource.wolfsonmicro.com>
 <20120926163145.GK10147@mail.gnudd.com>
 <20120926164932.GS4428@opensource.wolfsonmicro.com>
 <20120927134110.GD6799@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927134110.GD6799@mail.gnudd.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:41:10PM +0200, Davide Ciminaghi wrote:

> Maybe there's another solution: what about adding a couple of function
> pointers (lock, unlock) to struct regmap_config ? If they're set to NULL,
> everything works as usual. If they're not NULL, regmap uses such functions
> to do locking and unlocking instead of the usual ones (and regmap_bus.fast_io
> is ignored). I think this wouldn't hurt existing regmap users and allow
> sta2x11-mfd to have just one spinlock for everything, no need for nested
> locking this way.

That might work, yes, and would be generally useful I think.  Or we
could add regmap based versions of the clock utilities (which would also
be useful anyway).  Or both.
