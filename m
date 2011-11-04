Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab1KDR0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:26:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38257 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932832Ab1KDR0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:26:19 -0400
Date: Fri, 4 Nov 2011 17:26:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator:TPS65910: VDD1/2 voltage selector count
Message-ID: <20111104172617.GA20002@opensource.wolfsonmicro.com>
References: <1320410928-20349-1-git-send-email-afzal@ti.com>
 <20111104140422.GA28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A90194B0@DBDE01.ent.ti.com>
 <20111104152559.GC28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019607@DBDE01.ent.ti.com>
 <20111104161855.GC28902@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019650@DBDE01.ent.ti.com>
 <20111104164009.GA753@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019691@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A9019691@DBDE01.ent.ti.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 04:48:09PM +0000, Mohammed, Afzal wrote:

> Effective voltage expression is (value1 * 12.5mV + 562.5 mV) * value2.

> In this value2 is being called as gain.

> value1 can have values from 3 to 75, both inclusive (73 steps)
> value2 can have from 1 to 3, both inclusive (3 numbers)

Right, that makes sense.  It looks like you need a new constant for the
gain and the existing constant for value1 should be renamed to make it
more obvious that it's not the only part of the selector, the current
constant is confusingly named given the above.
