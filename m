Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1D0JNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:13:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57139 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1D0JNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:13:21 -0400
Date: Wed, 27 Apr 2011 10:12:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Samuel Ortiz <sameo@linux.intel.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Message-ID: <20110427091252.GP17290@n2100.arm.linux.org.uk>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com> <4DB1A603.2090208@pengutronix.de> <EDC1056430EF4DA8A0D850CE1DEA28FC@subhasishg> <4DB7C5F7.3080103@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB7C5F7.3080103@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 09:29:59AM +0200, Marc Kleine-Budde wrote:
> On 04/27/2011 08:39 AM, Subhasish Ghosh wrote:
> > - Is it ok to have u32 etc for __iomem cookie ?
> 
> no - "void __iomem *" is "void __iomem *"

Actually, it is _provided_ you don't directly dereference it.  You can
then do pointer arithmetic on it in the usual way - which is about the
only valid thing to do with an __iomem pointer.  The voidness just acts
as an additional check against direct dereferences of this.

The important thing though is that the code passes sparse checks.
