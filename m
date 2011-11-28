Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1K1RdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:33:19 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:27659 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1K1RdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:33:16 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1322501456!3935396!80
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        Rafal Prylowski <prylowski@metasoft.pl>
Date: Mon, 28 Nov 2011 11:33:04 -0600
Subject: RE: [PATCH v2 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to
 reference an empty list
Thread-Topic: [PATCH v2 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to
 reference an empty list
Thread-Index: AcysKeS2W6oCPt+JQKSTrwI2GNjHewByY52w
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E96DACDC@AUSP01VMBX24.collaborationhost.net>
References: <1bb25192ca6c0dc6f3631a3f937120d560e4e643.1322304185.git.mika.westerberg@iki.fi>
 <e3de259ed9d1b39ee9ba9ce681133b126166cbb5.1322304185.git.mika.westerberg@iki.fi>
In-Reply-To: <e3de259ed9d1b39ee9ba9ce681133b126166cbb5.1322304185.git.mika.westerberg@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 26, 2011 3:54 AM, Mika Westerberg wrote:
> 
> If dma_terminate_all() is called before the ep93xx_dma_tasklet() gets to run,
> it tries to access an empty ->active list which results following OOPS:

[OOPS snipped...]

> To make the code a bit more robust against things like these, we modify
> ep93xx_dma_get_active() to return NULL in case of empty ->active list and make
> sure that callers handle this correctly.
> 
> Reported-by: Rafal Prylowski <prylowski@metasoft.pl>
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> ---
>  drivers/dma/ep93xx_dma.c |   60 ++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 48 insertions(+), 12 deletions(-)

Looks good.  Thanks.

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
