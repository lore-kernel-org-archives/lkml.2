Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2CSFTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:19:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49393 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754665Ab2CSFS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:18:58 -0400
Message-ID: <1332134336.23125.60.camel@joe2Laptop>
Subject: Re: [PATCH wireless-next 2/3] ath5k: Introduce _ath5k_printk to
 reduce code/text
From: Joe Perches <joe@perches.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 18 Mar 2012 22:18:56 -0700
In-Reply-To: <CAJ-Vmo=ceSV38vQGfs8cKJScWjYF4kbQdK3+JJvQLCmnURaEwA@mail.gmail.com>
References: <cover.1332116921.git.joe@perches.com>
	 <b157e2d1a746733d1814b9726f326d52d36da2fc.1332116921.git.joe@perches.com>
	 <CAJ-Vmo=ceSV38vQGfs8cKJScWjYF4kbQdK3+JJvQLCmnURaEwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-18 at 21:36 -0700, Adrian Chadd wrote:
> Hi,

Hi Adrian.

> So the reason this is a macro in the FreeBSD HAL is so that the args
> aren't evaluated unless the level (or debug bitmap in my case) fires
> off.
> 
> Otherwise compiling in debugging will cause a _lot_ of spurious
> register reads to occur that are then tossed. This was one of the big
> reasons for instability and slow performance when AH_DEBUG was
> enabled.

That doesn't make any sense in this case.

It's either a call to printk or _ath5_printk
but it's still a call to a function.

+void __printf(3, 4)
+_ath5k_printk(const struct ath5k_hw *ah, const char *level,
+             const char *fmt, ...);
+
 #define ATH5K_PRINTK(_sc, _level, _fmt, ...)                           \
-       printk(_level pr_fmt("%s%s" _fmt),                              \
-              ((_sc) && (_sc)->hw) ? wiphy_name((_sc)->hw->wiphy) : "", \
-              ((_sc) && (_sc)->hw) ? ": " : "",                        \
-              ##__VA_ARGS__)
+       _ath5k_printk(_sc, _level, _fmt, ##__VA_ARGS__)

If there are level/mask tests to macros that
are used to call ATH5K_PRINTK, that still
works.  As far as I can tell, there aren't
any uses of macros like that.

cheers, Joe


