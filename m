Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1LIOgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:36:24 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51383 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1LIOgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:36:23 -0500
Message-ID: <20194.7382.414612.182139@ipc1.ka-ro>
Date: Fri, 9 Dec 2011 15:36:06 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: mxs: add .owner to struct
 snd_soc_card
In-Reply-To: <20111209141203.GH3327@pengutronix.de>
References: <cover.1323436034.git.LW@KARO-electronics.de>
	<555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
	<20111209141203.GH3327@pengutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Wolfram Sang writes:
> On Fri, Dec 09, 2011 at 02:38:09PM +0100, Lothar Waßmann wrote:
> > This will prevent the module from being removed from underneath its
> > users
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> 
> I can't find any other instance setting owner in snd_soc_card?
> 
Then that other uses are most probably faulty too.

You can easily test it by loading all necessary sound modules,
starting some application that uses the sound device (e.g. alsamixer)
and then removing the snd-soc-mxs-sgtl5000 module.

Without the patch the removal will succeed crashing the
application. With this patch the refcount of the module will be
> 0 as long as an application is using it, preventing the
removal.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
