Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0KJObR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:31:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47489 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab0KJObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:31:16 -0500
Date: Wed, 10 Nov 2010 14:31:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Minkyu Kang <promsoft@gmail.com>
Cc: Greg KH <greg@kroah.com>, Minkyu Kang <mk7.kang@samsung.com>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com,
        Ben Dooks <ben-i2c@fluff.org>
Subject: Re: [PATCH v2] misc: adds support the FSA9480 USB Switch
Message-ID: <20101110143110.GA5043@sirena.org.uk>
References: <4C7CD95A.5040309@samsung.com> <20100917150731.f1f44f3c.akpm@linux-foundation.org> <AANLkTim2UhJAhOw1qHvZ9bbctR0tNSMvE61T=sxffHxO@mail.gmail.com> <4CB26931.5040105@samsung.com> <20101011173649.GC7116@kroah.com> <AANLkTi=vTkHJJ2dq5RZHHCwWYEBtY=Y7dPPh=Wzzx95f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vTkHJJ2dq5RZHHCwWYEBtY=Y7dPPh=Wzzx95f@mail.gmail.com>
X-Cookie: What fools these morals be!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 09:55:34AM +0900, Minkyu Kang wrote:
> Dear Greg KH,

> > And why are you exporting symbols from this driver, that should not be
> > needed at all.

> It's for other drivers.
> For example.. When USB cable is connected, PMIC driver enable the
> power for each device. (USB, uart, audio and so on..)
> But if use the manual switch, PMIC driver can't know what device is enabled.
> So, this function was exported.

This seems like it would require the PMIC driver to have knowledge of
the USB switch driver which would be likely to give a system which is
rather board specific.  For PMIC supply management integration the
regulator API would be more normal.
