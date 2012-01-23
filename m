Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2AWLw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 06:52:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44103 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab2AWLw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 06:52:28 -0500
Date: Mon, 23 Jan 2012 11:52:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mfd regmap irq to handle some cases
Message-ID: <20120123115225.GB29465@opensource.wolfsonmicro.com>
References: <1327308423.23929.8.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327308423.23929.8.camel@dhruva>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 02:17:03PM +0530, Ashish Jangam wrote:

Please fix your mailer to word wrap within 80 columns.  I've reflowed
your text for legibility.

> For a quick fix in regmap irq we may tempt to defer event
> clarification after processing of event but there is a problem in this

That's not going to work in general, it means there's a race between
handling the interrupt and acknowledging the interrupt which leads to
interrupts being dropped if you get a new interrupt before the ack has
been written back.

> approach for some variants of DA9052 and DA9053 when event is cleared
> a spurious interrupt gets generated therefore in earlier release of
> DA9052/53 MFD module a delay was added. Therefore we need to think on
> how to handle such cases in regmap irq.

What are the consequences of the spurious interrupt?
