Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0LQMyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:54:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43830 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0LQMyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:54:52 -0500
Date: Fri, 17 Dec 2010 12:54:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rabin Vincent <rabin@rab.in>
Cc: rjw@sisk.pl, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Message-ID: <20101217125427.GA29640@sirena.org.uk>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
X-Cookie: Yow!  Am I in Milwaukee?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 11:56:57PM +0530, Rabin Vincent wrote:

> There seem to be some differences between the generic ops and the i2c
> and platform busses' implementations of the interaction between runtime
> PM and system sleep:

>   (1) The platform bus does not implement the
>       don't-call-pm->suspend()-if pm_runtime_suspended()-returns-true
>       functionality implemented by the generic ops and i2c.

This is platform lagging behind I2C in implementation - both originally 
did what platform does and then I2C was updated and platform wasn't.

It'd be really good if this could all be factored out into the PM core,
we're going to have to do the same thing for at least SPI as well and
possibly some other buses :/
