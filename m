Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab1EJWkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:40:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49581 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab1EJWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:40:50 -0400
Date: Tue, 10 May 2011 23:40:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Joe Perches <joe@perches.com>, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
Message-ID: <20110510224045.GA19154@sirena.org.uk>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com> <1304365077.7792.40.camel@Joe-Laptop> <BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
X-Cookie: One picture is worth 128K words.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 12:18:00AM +0200, Linus Walleij wrote:

> This is the idiomatic way of providing sysfs strings (compare e.g.
> *_show() in drivers/regulator/core.c), the char *buf comes
> from the sysfs core in struct device_attribute in <linus/device.h>
> with this prototype:

>  ssize_t (*show)(struct device *dev, struct device_attribute *attr,
>                         char *buf);

> and I have no way of knowing how large that buffer is. Migrating all

It's implicitly PAGE_SIZE.  In pretty much all users the buffer is
constrained to well below that by the inputs (sometimes with some help
from users not using insanely long names for things) and the sysfs
semantics which mean you probably got something badly wrong if you get
anywhere near PAGE_SIZE.
