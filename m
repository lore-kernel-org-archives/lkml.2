Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2HGRDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:03:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58999 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688Ab2HGRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:03:36 -0400
Date: Tue, 7 Aug 2012 18:03:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120807170333.GV16861@opensource.wolfsonmicro.com>
References: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
 <20120806081915.GA4518@core.coreip.homeip.net>
 <20120806153750.GI10524@gmail.com>
 <20120806160226.GF29272@sirena.org.uk>
 <20120807170129.GA3759@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807170129.GA3759@gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 06:01:30PM +0100, Lee Jones wrote:

> Okay, so I've just spent a small amount of time looking at this. I think
> the best place for this would be in *_get_virq(), using the same logic that
> selected a *_legacy or *_linear domain in the first place. The only thing 
> the domain can test for is the 'type' of domain and the requested IRQ. This
> is where the issue lies. If a hwirq to virq conversion is requested, but a
> virq is passed (which happens in the non-DT case) a WARN() is triggered
> because the irq passed is bigger than first_irq + size. I think *_get_virq()
> should ensure that only a hwirq is passed to irq_create_mapping().

> Let me know if you had other ideas.

I'd expect your driver to always pass a hwirq into _get_virq() here.
