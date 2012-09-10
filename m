Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2IJGqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:46:03 -0400
Received: from bitmer.com ([213.157.87.50]:47236 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab2IJGp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:45:58 -0400
Date: Mon, 10 Sep 2012 09:45:58 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-watchdog@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko.nikula@jollamobile.com
Subject: Re: [PATCH v2] watchdog: omap_wdt: convert to new watchdog core
Message-Id: <20120910094558.b4e569e67505d3f61bead2d5@bitmer.com>
In-Reply-To: <1347127441-23125-1-git-send-email-aaro.koskinen@iki.fi>
References: <1347127441-23125-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  8 Sep 2012 21:04:01 +0300
Aaro Koskinen <aaro.koskinen@iki.fi> wrote:

> Convert omap_wdt to new watchdog core. On OMAP boards, there are usually
> multiple watchdogs. Since the new watchdog core supports multiple
> watchdogs, all watchdog drivers used on OMAP should be converted.
> 
> The legacy watchdog device node is still created, so this should not
> break existing users.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---
> 
> v2: Fix a bug in the first version of the patch: __omap_wdt_disable()
> in probe was mistakenly moved outside PM runtime calls. This caused a
> crash as device was probably accessed with some clocks off. Thanks to
> Jarkko Nikula <jarkko.nikula@bitmer.com> for reporting this.
> 
>  drivers/watchdog/Kconfig    |    1 +
>  drivers/watchdog/omap_wdt.c |  266 ++++++++++++++++++-------------------------
>  2 files changed, 114 insertions(+), 153 deletions(-)
> 
Tested-by: Jarkko Nikula <jarkko.nikula@jollamobile.com>
