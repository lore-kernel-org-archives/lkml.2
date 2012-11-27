Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2K0Fzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:55:53 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55343 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2K0Fzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:55:51 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Hebbar\, Gururaja" <gururaja.hebbar@ti.com>, alsa-devel@alsa-project.org,
        sudhakar.raj@ti.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        nsekhar@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        perex@perex.cz, lrg@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ASoC: davinci-mcasp: Add pinctrl support
References: <1353557099-21599-1-git-send-email-gururaja.hebbar@ti.com>
	<1353557099-21599-2-git-send-email-gururaja.hebbar@ti.com>
	<20121126114511.GE9411@opensource.wolfsonmicro.com>
Date: Mon, 26 Nov 2012 21:55:33 -0800
In-Reply-To: <20121126114511.GE9411@opensource.wolfsonmicro.com> (Mark Brown's
	message of "Mon, 26 Nov 2012 11:45:11 +0000")
Message-ID: <87y5hn1tey.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mark" == Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

Hi,

 Mark> On Thu, Nov 22, 2012 at 09:34:58AM +0530, Hebbar, Gururaja wrote:
 >> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
 >> +	if (IS_ERR(pinctrl))
 >> +		dev_warn(&pdev->dev,
 >> +			"pins are not configured from the driver\n");

 Mark> Since the driver is happy to continue without the pins why is it
 Mark> bothering requesting them in the first place?  In other words, this
 Mark> should be a hard error.

Sorry, I disagree. As was discussed recently, there's several reasons
why the pinctrl call might fail, and not all are fatal (E.G. pinmux
already setup by bootloader):

http://article.gmane.org/gmane.linux.kernel/1399756

-- 
Bye, Peter Korsgaard
