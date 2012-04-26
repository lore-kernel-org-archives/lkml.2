Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2DZMle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:41:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57499 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2DZMld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:41:33 -0400
Date: Thu, 26 Apr 2012 13:41:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120426124122.GA26692@sirena.org.uk>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1334935826-12527-2-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334935826-12527-2-git-send-email-jhovold@gmail.com>
X-Cookie: TAILFINS!! ... click ...
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 05:30:23PM +0200, Johan Hovold wrote:

> +static int __lm3533_read(struct lm3533 *lm3533, u8 reg, u8 *val)
> +{
> +	int ret;
> +
> +	ret = lm3533->read(lm3533, reg, val);
> +	if (ret < 0) {

Looks like you could save a bunch of code by using regmap for the
register I/O.  This would also give you access to the cache and
diagnostic infrastructure it has.
