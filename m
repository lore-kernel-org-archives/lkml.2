Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab1BRWQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:16:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48605 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1BRWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:16:27 -0500
Date: Fri, 18 Feb 2011 22:16:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, khilman@ti.com, magnus.damm@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        stern@rowland.harvard.edu, linux-i2c@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Message-ID: <20110218221606.GB25168@sirena.org.uk>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <201102181928.05911.rjw@sisk.pl> <AANLkTi=j9KeX2TSzMaKMWR6GpXjFcsjp0z8Rt+ArLXiV@mail.gmail.com> <201102182120.29977.rjw@sisk.pl> <20110218202744.GA19427@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218202744.GA19427@n2100.arm.linux.org.uk>
X-Cookie: Opened for inspection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 08:27:44PM +0000, Russell King - ARM Linux wrote:

> Do we have any pressing need to convert AMBA stuff?  I haven't heard any
> reason yet to convert them to runtime PM - they don't even make any
> runtime PM calls.

There's a bit of a chicken and egg problem in that it's not possible for
devices to make use of runtime PM unless the bus has runtime PM support
implemented - the bus implementation is mandatory, there's no default.
