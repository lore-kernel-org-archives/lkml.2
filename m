Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2EUFcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 01:32:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36328 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2EUFcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 01:32:07 -0400
Date: Sun, 20 May 2012 22:32:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Ujfalusi, Peter" <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] Input: twl6040-vibra: Update for device tree support
Message-ID: <20120521053159.GA30285@core.coreip.homeip.net>
References: <1337167186-8535-1-git-send-email-peter.ujfalusi@ti.com>
 <20120516193546.GA15920@core.coreip.homeip.net>
 <CAPo=G1zf1XJcoKgCxMn3X09T0LOUG-9aw3iopqC7OPqcuc5hcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPo=G1zf1XJcoKgCxMn3X09T0LOUG-9aw3iopqC7OPqcuc5hcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:55:13PM +0300, Ujfalusi, Peter wrote:
> Hi Dmitry,
> 
> On Wed, May 16, 2012 at 10:35 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > So in this case why don't you have parent parse all DT data and
> > construct instance of pdata for vibra driver to consume?
> 
> If there is a need to change the parameters (add new ones for example)
> for the vibra driver in this way the change in code only need to be
> done in the vibra driver.
> If the MFD core would construct the pdata, in this case I would need
> to modify both the MFD core and vibra driver.

Hmm, I am getting:

  CC      drivers/input/misc/twl6040-vibra.o
drivers/input/misc/twl6040-vibra.c: In function ‘twl6040_vibra_probe’:
drivers/input/misc/twl6040-vibra.c:263:9: error: implicit declaration of
function ‘of_find_node_by_name’ [-Werror=implicit-function-declaration]
drivers/input/misc/twl6040-vibra.c:263:42: warning: initialization makes
pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[1]: *** [drivers/input/misc/twl6040-vibra.o] Error 1
make: *** [drivers/input/misc/twl6040-vibra.o] Error 2


it looks like there is no stub for of_find_node_by_name().

Thanks.

-- 
Dmitry
