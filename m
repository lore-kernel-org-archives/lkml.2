Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1HaQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:16:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61959 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab1HaQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:16:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6455"; a="114141868"
Date: Wed, 31 Aug 2011 11:16:16 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: [patch v2 17/35] Hexagon: Add interrupts
Message-ID: <20110831161616.GA11117@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org>
 <20110830190801.353140948@codeaurora.org>
 <201108311550.23240.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108311550.23240.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 03:50:23PM +0200, Arnd Bergmann wrote:
> > +/*
> > + * XXX TODO FIXME this should be pulled from a platform file!
> > + * Must define NR_IRQS before including <asm-generic/irq.h>
> > + * 64 == the two SIRC's, 176 == the two gpio's
> > + */
> > +#define NR_IRQS (HEXAGON_CPUINTS + 64 + 176)
> 
> I disagree with that comment: NR_IRQS is a constant and should
> not be platform specific. There should be no compile-time settings
> that are strictly specific to one platform, otherwise you are not

OK.  The interrupt handling on hexagon really is under construction:
not only do we need to finish support for the device tree, but there's
also a bunch of nasty ugliness in how the second & third-level
interrupt cntrollers are handled.  Some of the difficulties are due
the fact that we are re-cycling some of the msm drivers in the 
arm platform directories. The hexagon and the arm are on the same
chip, and see the same controllers, more or less, just with 
different address ranges and sometimes with different permissions,
different pin numberings, etc. 

Some of these patches are missing Signed-off-by-me lines, I take
full responsibility for all triple-X's that are lingering.

-- Linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
