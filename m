Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1JXLfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:35:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40746 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab1JXLfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:35:52 -0400
Date: Mon, 24 Oct 2011 13:35:37 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Rajendra Nayak <rnayak@ti.com>, broonie@opensource.wolfsonmicro.com,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024113537.GH8708@ponder.secretlab.ca>
References: <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
 <20111021115809.GB337@S2100-06.ap.freescale.net>
 <4EA4FF6B.2080906@ti.com>
 <20111024081706.GC8708@ponder.secretlab.ca>
 <20111024090228.GA1755@S2100-06.ap.freescale.net>
 <4EA52851.8000203@ti.com>
 <20111024091158.GB1755@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024091158.GB1755@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 05:11:58PM +0800, Shawn Guo wrote:
> On Mon, Oct 24, 2011 at 02:26:49PM +0530, Rajendra Nayak wrote:
> > On Monday 24 October 2011 02:32 PM, Shawn Guo wrote:
> > >Okay, it's wrong then since so many people say it's wrong :)  I guess
> > >a quick fix would be adding one property in device tree node for
> > >matching some unique field in regulator_desc, id, maybe?  Mark, any
> > >suggestion?
> > 
> > Thats basically what the DT compatible property is for :)
> 
> But adding compatible property will get DT core create 'struct dev'
> for each regulator node, while we are trying to avoid that since
> regulator core has been doing this.

By design, of_platform_populate() will only go one level deep except
if it matches the passed in list of bus compatible properties.  Having
a compatible property does not necessarily create a struct dev.

That said, I agree with you that a compatible property isn't really
needed in the child nodes **if it is defined as part of the parent
node's binding**.

g.

