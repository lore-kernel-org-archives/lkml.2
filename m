Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0HBIFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:05:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55447 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0HBIFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:05:40 -0400
Date: Mon, 2 Aug 2010 10:05:38 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 9/9] kconfig: add savedefconfig
Message-ID: <20100802080538.GA13449@pengutronix.de>
References: <20100731213429.GA8200@merkur.ravnborg.org> <1280612134-8220-9-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1280612134-8220-9-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jul 31, 2010 at 11:35:34PM +0200, Sam Ravnborg wrote:
> savedefconfig will save a minimal config to a file
> named "defconfig".
> 
> The config symbols are saved in the same order as
> they appear in the menu structure so it should
> be possible to map them to the relevant menus
> if desired.
> 
> The implementation was tested against several minimal
> configs for arm which was created using brute-force.
s/was/were/ I think.

> There was one regression related to default numbers
> which had their valid range further limited by another symbol.
> 
> Sample:
> 
> config FOO
> 	int "foo"
> 	default 4
> 
> config BAR
> 	int "bar"
> 	range 0 FOO
> 
> If FOO is set to 3 then BAR cannot take a value higher than 3.
> But the current implementation will set BAR equal to 4.
> 
> This is seldomly used and the final configuration is OK,
> and the fix was non-trivial.
> So it was documented in the code and left as is.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
