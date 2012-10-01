Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2JAKQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:16:49 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:3873 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798Ab2JAKQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:16:48 -0400
Message-ID: <1349086606.24442.13.camel@x61.thuisdomein>
Subject: Re: [PATCH] regmap: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Oct 2012 12:16:46 +0200
In-Reply-To: <20121001100321.GB4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
	 <20121001100321.GB4360@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Oct 2012 10:16:47.0757 (UTC) FILETIME=[DD8293D0:01CD9FBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 11:03 +0100, Mark Brown wrote:
> On Sun, Sep 30, 2012 at 12:15:55PM +0200, Paul Bolle wrote:
> > Building regmap.o triggers this GCC warning:
> >     drivers/base/regmap/regmap.c: In function ‘regmap_raw_read’:
> >     drivers/base/regmap/regmap.c:1172:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> > 
> > It seems 'ret' should always be set when this function returns. See, the
> > else-branch can leave 'ret' uninitialized only if 'val_count' is zero.
> > But if 'val_count' is zero regmap_volatile_range() will return true.
> > That implies that 'ret' will be set in the if-branch. ('val_count' could
> > be zero if 'val_len' is, for example, zero. That would be useless input,
> > however.)
> > 
> > Anyhow, initializing 'ret' to -EINVAL silences GCC and is harmless.
> 
> Have you reported this bug in GCC?

No I haven't. Since you ask, I guess you too think 'ret' is always set
when this function returns, don't you? Ie, my analysis isn't obviously
wrong.

> Their flow analyis just seems to keep on getting worse and worse.


Paul Bolle

