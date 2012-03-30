Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab2C3Lhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:37:46 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33805 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561Ab2C3Lhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:37:39 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Anatolij Gustschin <agust@denx.de>,
        Andreas Koensgen <ajk@comnets.uni-bremen.de>,
        Andrew Lunn <andrew@lunn.ch>, Andrew Victor <linux@maxim.org.za>,
        Arnd Bergmann <arnd@arndb.de>, Barry Song <baohua.song@csr.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, cbe-oss-dev@lists.ozlabs.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        Eric Miao <eric.y.miao@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Grant@igel.home, "Likely <gran"@igel.home
Subject: Re: [PATCH 00/17] mark const init data with __initconst instead of __initdata
References: <20120329211131.GA31250@pengutronix.de>
	<20120330095859.GT15647@pengutronix.de>
X-Yow: Tex SEX!  The HOME of WHEELS!  The dripping of COFFEE!!  Take me
 to Minnesota but don't EMBARRASS me!!
Date: Fri, 30 Mar 2012 13:37:26 +0200
In-Reply-To: <20120330095859.GT15647@pengutronix.de> ("Uwe =?utf-8?Q?Klein?=
 =?utf-8?Q?e-K=C3=B6nig=22's?=
	message of "Fri, 30 Mar 2012 11:59:00 +0200")
Message-ID: <m2bone7215.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

> After a question by Shawn Guo I noticed that my command to do the changes
> was to lax and changed things that must not be changed (at least not
> with further care). Affected are lines like:
>
> 	static const char *at91_dt_board_compat[] __initconst = {
>
> While at91_dt_board_compat[0] is const, at91_dt_board_compat is not.

Though it looks like at91_dt_board_compat should really be const (it is
assigned to a const pointer, likewise for all other uses of struct
machine_desc.dt_compat).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
