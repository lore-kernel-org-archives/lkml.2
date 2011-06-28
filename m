Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab1F1RE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:04:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab1F1RDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:03:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] PWM: add pwm framework support
Date: Tue, 28 Jun 2011 19:03:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de> <201106281427.04373.arnd@arndb.de> <20110628161842.GK6069@pengutronix.de>
In-Reply-To: <20110628161842.GK6069@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281903.06121.arnd@arndb.de>
X-Provags-ID: V02:K0:C99Dx9x3AdL0B0+5i3nHEVQ9PCcVrmqwZ/M/sFB+eCO
 eELoaJZ/nhrXx+IEbJih66Y4W70O8C8OinfJsko+CoX9XxMsgM
 s6whdu3g+mstvGHTuOsKLkZG9bnegjU2vkcIKCyWMyX0J+oOWx
 o85c4a4lzPd84srWbUOy7626G8NPfymjaiGyke7ylXqKrDMDOE
 55OJVnuUD2SnWmj7r/Ekg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Sascha Hauer wrote:
> > How about using idr? It provides you a fast lookup and handles giving
> > out unique numbers.
> 
> Sounds like a good idea, but is idr compatible with the pwmchip_reserve
> function below? idr gives no guarantee that the first id is zero, but I
> need exactly this to make the ids for the internal PWMs known at compile
> time.

You can certainly use ida_get_new_above to guarantee that implicit
number allocation doesn't interfere with the reserved numbers. Whether
that guarantees that you get the reserved numbers when you ask for them,
I don't know.

A possible way to deal with that would be to allocate an array of pointers
for the reserved space but use IDR for the rest, but at that point the
complexity is probably higher than what you have now ;-)

Another question is whether the dynamic allocation even makes sense. How
does a driver that wants to use a PWM find out what number to ask for
when it's not reserved for the platform to start with. Maybe the
answer is to just use an array or tree for the lookup and refuse to
register multiple PWMs to the same number.

	Arnd
