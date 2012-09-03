Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2ICDJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:09:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34980 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2ICDJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:09:10 -0400
Date: Mon, 3 Sep 2012 11:09:01 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 1/7] mfd: add syscon driver based on regmap
Message-ID: <20120903030858.GF2362@S2101-09.ap.freescale.net>
References: <1346237818-9498-1-git-send-email-b29396@freescale.com>
 <1346237818-9498-2-git-send-email-b29396@freescale.com>
 <20120831012626.GA7726@r65073-Latitude-D630>
 <20120903023102.GA11891@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903023102.GA11891@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 10:31:03AM +0800, Dong Aisheng wrote:
> > 
> > I think of_node_put should be moved out from here and put into
> > syscon_node_to_regmap and syscon_regmap_lookup_by_compatible.
> > 
> I guess no, if you want to move of_node_put into syscon_regmap_lookup_by_phandle,
> then syscon_regmap_lookup_by_phandle has the same issue.

I guess not.  syscon_regmap_lookup_by_phandle itself calls of_parse_phandle,
and that's where the refcount gets incremented, so syscon_regmap_lookup_by_phandle
should be responsible for calling of_node_put to get the refcount decremented.

-- 
Regards,
Shawn
