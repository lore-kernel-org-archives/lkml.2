Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1IOOAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:00:37 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:55870 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753892Ab1IOOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:00:36 -0400
Date: Thu, 15 Sep 2011 15:23:01 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v2] [media] at91: add code to initialize and manage the
 ISI_MCK for Atmel ISI driver.
Message-ID: <20110915132301.GK28104@game.jcrosoft.org>
References: <1315288601-22384-1-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109060803590.14818@axis700.grange>
 <20110906200512.GA15083@game.jcrosoft.org>
 <4E668BBF.4020600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E668BBF.4020600@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 94575594050595807
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrfeefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:08 Tue 06 Sep     , Sylwester Nawrocki wrote:
> On 09/06/2011 10:05 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> I'm not entirely sure on this one, but as we had a similar situation with
> >> clocks, we decided to extablish the clock hierarchy in the board code, and
> >> only deal with the actual device clocks in the driver itself. I.e., we
> >> moved all clk_set_parent() and setting up the parent clock into the board.
> >> And I do think, this makes more sense, than doing this in the driver, not
> >> all users of this driver will need to manage the parent clock, right?
> >
> > I don't like to manage the clock in the board except if it's manadatory otherwise
> > we manage this at soc level
> > 
> > the driver does not have to manage the clock hierachy or detail implementation
> > but manage the clock enable/disable and speed depending on it's need
> 
> We had a similar problem in the past and we ended up having the boot loader
> setting up the parent clock for the device clock. The driver only controls clock
> gating and sets its clock frequency based on an internal IP version information,
> derived from the SoC revision.
sorry NACK

I do not want to rely on bootloader
when we will have the DT we will pass it via it right now we need find an
other generic way

Best Regards,
J.
