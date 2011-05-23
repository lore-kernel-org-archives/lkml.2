Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1EWKzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:55:35 -0400
Received: from mail175c2.megamailservers.com ([69.49.111.75]:40171 "EHLO
	mail175c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab1EWKze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:55:34 -0400
X-Greylist: delayed 4623 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 May 2011 06:55:33 EDT
X-Authenticated-User: kristoffer.gaisler.com
Message-ID: <4DDA2AC0.1060406@gaisler.com>
Date: Mon, 23 May 2011 11:37:04 +0200
From: Kristoffer Glembo <kristoffer@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070601 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Kevin Hilman <khilman@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com>	<20110519233958.GB18181@ponder.secretlab.ca>	<4DD66B8A.5040404@gmail.com>	<201105201621.03801.arnd@arndb.de> <4DD68614.6090209@gmail.com>	<a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local> <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
In-Reply-To: <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=DS5eMQQtQ4nFbUAEtHoylkid/yBh9OhBXgXKFyMy8+c= c=1 sm=1
		a=XR04_yjgki4A:10 a=ux9R6aFfsoIA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=7V2oU7nvVHfVZ2do0z0A:9 a=wPNLvfGTeEIA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Grant Likely wrote:
> In the case we're talking about the bus really is an AMBA bus, and all
> the devices on it are in some sense real amba devices.  The problem is
> that not all of the devices on the bus implement peripheral ID
> registers or other mechanisms that good upstanding AMBA devices are
> expected to have.  


Before we go hardware bashing of non primecell AMBA devices I would just
want to point out that the primecell stuff is not part of the AMBA specification.

So the "amba bus" should really have a way of marking which devices are primecell
devices instead of assuming this.

We (Aeroflex Gaisler) use an AMBA bus on our LEON SPARC chips but don't have any primecells 
devices. We went the of_platform_driver route after concluding that the AMBA bus in Linux is 
really not an AMBA bus at all. Our bus is fully probable though as all information about the 
present devices are memory mapped in a "plug and play" area.

On the other hand, there is not much point of an AMBA bus driver which does nothing more than
the platform driver. But AMBA is really a misnomer in this case.

/Kristoffer
