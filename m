Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2JAKDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:03:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40492 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab2JAKDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:03:23 -0400
Date: Mon, 1 Oct 2012 11:03:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
Message-ID: <20121001100321.GB4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349000155.1553.27.camel@x61.thuisdomein>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 12:15:55PM +0200, Paul Bolle wrote:
> Building regmap.o triggers this GCC warning:
>     drivers/base/regmap/regmap.c: In function ‘regmap_raw_read’:
>     drivers/base/regmap/regmap.c:1172:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> It seems 'ret' should always be set when this function returns. See, the
> else-branch can leave 'ret' uninitialized only if 'val_count' is zero.
> But if 'val_count' is zero regmap_volatile_range() will return true.
> That implies that 'ret' will be set in the if-branch. ('val_count' could
> be zero if 'val_len' is, for example, zero. That would be useless input,
> however.)
> 
> Anyhow, initializing 'ret' to -EINVAL silences GCC and is harmless.

Have you reported this bug in GCC?  Their flow analyis just seems to
keep on getting worse and worse.
