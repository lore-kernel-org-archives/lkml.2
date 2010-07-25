Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0GYTn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 15:43:58 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:32830 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0GYTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 15:43:57 -0400
Date: Sun, 25 Jul 2010 22:38:51 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Hari Kanigeri <hari.kanigeri@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Richard Woodruff <r-woodruff2@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] save and restore etm state across core OFF modes
Message-ID: <20100725193851.GA14399@shisha.kicks-ass.net>
Mail-Followup-To: Hari Kanigeri <hari.kanigeri@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Richard Woodruff <r-woodruff2@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
 <1280077520-7538-7-git-send-email-virtuoso@slind.org>
 <AANLkTinmSJ6dtgqmyuk9CArniPEvEp7TrXauvGxLxv7x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinmSJ6dtgqmyuk9CArniPEvEp7TrXauvGxLxv7x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 12:34:22 -0600, Hari Kanigeri wrote:
> > +config ENABLE_OFF_MODE_JTAG_ETM_DEBUG
> > + š š š bool "Enable hardware emulation context save and restore"
> > + š š š depends on ARCH_OMAP3
> 
> -- Shouldn't this be depends on OMAP3_EMU instead ?

Not really. OMAP3_EMU will enable ETM/ETB drivers within omap, but this
particular patch is also needed if you're using an external hardware
debugger to debug code across OFF modes.

> > + š š š default y
> 
> -- As this is debug option, can you keep this "n" by default ?

This option allows for enabling certain debugging functionality in runtime
(via a sysfs file), which is turned off by default. It is debatable whether
this option should default to 'y' or 'n', seeing as it doesn't add much
overhead to the normal usecase.

> > + š š š help
> > + š š š š This option enables JTAG & ETM debugging across power states.
> > + š š š š With out this option emulation features are reset across OFF
> > + š š š š mode state changes.

But I see that the wording is misleading and unclear, so I'll try to come
up with something more descriptive.

Regards,
--
Alex
