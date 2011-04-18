Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1DRIuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:50:20 -0400
Received: from outbound.icp-osb-irony-out8.iinet.net.au ([203.59.1.134]:41579
	"EHLO outbound.icp-osb-irony-out8.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab1DRIuR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:50:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBACH6q03LrQ63/2dsb2JhbAAMrzK5HoVxBJIS
X-IronPort-AV: E=Sophos;i="4.64,231,1301846400"; 
   d="scan'208";a="3493401"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <20110418091902.13345132@lxorguk.ukuu.org.uk>
Date: Mon, 18 Apr 2011 18:50:12 +1000
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/04/2011, at 6:19 PM, Alan Cox wrote:

>> gpiolib handles input and output, high and low because that's all that could reasonably be expected to a) always work and b) be changed at run time in the driver.
> 
> Imagine if file systems only handled 8.3 filenames because that's all
> that could reasonably be expected to a) always work !

Fair call, but bringing this back to the particular case in hand what in that enum is worth 'hinting' in a might-have-an-effect manner rather than just letting the board take care of it?

Still my question stands, where is the driver ever better placed to make these calls than the board code?

> 
>> So in short - what's the use case?  Which driver requires this?
>> 
> 
> Also your comment re simply in or out on or off is incorrect. Pins may
> also be in use by firmware and the like and in a 'neither' state.
> Something certain gpio people seem to be in denial over.

Quite right, but should a pin ever be in a neither state and simultaneously controlled by a gpiolib driver?  If so, how should it behave and if not, is it anything that stricter enforcement of gpio_request() semantics can't get around?

	--Ben.

> 
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

