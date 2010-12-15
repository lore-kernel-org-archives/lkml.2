Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0LOVVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:21:13 -0500
Received: from trinity.fluff.org ([89.16.178.74]:38225 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0LOVVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:21:10 -0500
Date: Wed, 15 Dec 2010 21:21:04 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>, lkml <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] GPIO_SCH and I2C_SCH: select MFD_SUPPORT to eliminate
	kconfig warnings
Message-ID: <20101215212104.GA20097@trinity.fluff.org>
References: <20101214162656.b8550c70.randy.dunlap@oracle.com> <20101215101541.5952780f@endymion.delvare> <4D0920DD.3080306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0920DD.3080306@oracle.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 12:11:09PM -0800, Randy Dunlap wrote:
> On 12/15/10 01:15, Jean Delvare wrote:
> > Hi Randy,
> > 
> > On Tue, 14 Dec 2010 16:26:56 -0800, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> I2C_ISCH and GPIO_SCH need to select MFD_SUPPORT so that the
> >> dependency tree hierarchy is satisfied.  This eliminates the
> >> kconfig warning:
> >>
> >> warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI)
> >>

Hmm, it seems that MFD_SUPPORT enables MFD_CORE, and as such, I don't
think MFD_CORE can be selected without the MFD_SUPPORT.

My view would be to add MFD_NEEDED, or NEEDS_MFD which would force
the MFD_SUPPORT and MFD_CORE on in one go.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

