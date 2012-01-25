Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2AYNfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:35:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40924 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab2AYNfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:35:21 -0500
Date: Wed, 25 Jan 2012 13:35:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mfd regmap irq to handle some cases
Message-ID: <20120125133518.GK3687@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDCFCAF@KCHJEXMB01.kpit.com>
 <1327325611.23929.15.camel@dhruva>
 <20120123151830.GA21857@opensource.wolfsonmicro.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1FDCFDBC@KCHJEXMB01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDCFDBC@KCHJEXMB01.kpit.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 04:28:29AM +0000, Ashish Jangam wrote:

> > > There will processing of false events which is undesirable.

> > But what actually happens?  RTC interrupts aren't going to be high
> > volume, if we get the odd spurious interrupt and handle it gracefully
> > I'm not sure we really care.

> spurious interrupt we get on clearing event and event can be from any
> mfd children. But since now, deferring event clear is not the approach
> we can ignore about the spurious interrupt.
> Now looking at the old issue of determining the RTC type (periodic or tick)
> on event clearing this info (RTC type) gets lost for the register since in regmap_irq
> we first clear and then process the event.

That we can handle easily enough by adding a flag to the interrupt
definition deferring the acknowledgement.
