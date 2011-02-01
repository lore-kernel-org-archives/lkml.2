Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1BAUGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:06:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56618 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1BAUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:06:14 -0500
Date: Tue, 1 Feb 2011 15:06:09 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
In-Reply-To: <20110201193201.GH1147@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1102011503550.8580@xanadu.home>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de> <20110201131512.GH31216@n2100.arm.linux.org.uk> <20110201141837.GA1147@pengutronix.de> <20110201143932.GK31216@n2100.arm.linux.org.uk> <20110201151846.GD1147@pengutronix.de>
 <20110201152458.GP31216@n2100.arm.linux.org.uk> <20110201155344.GF1147@pengutronix.de> <20110201170637.GR31216@n2100.arm.linux.org.uk> <20110201193201.GH1147@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-845050105-1296590771=:8580"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-845050105-1296590771=:8580
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 1 Feb 2011, Uwe Kleine-König wrote:

> My motivation for a more complicated clk_prepare was to make clk_prepare
> atomic when that's possible (i.e. when the clk is already prepared) and
> call it before the enable callback in clk_enable.  Then everything
> behaves nicely even if clk_enable is called from atomic context provided
> that the clock was prepared before (or doesn't need to).

NOOOOOOOOO!!!

We _do_ want drivers to _always_ call clk_prepare() in sleepable 
context, and _then_ always call clk_enable() in whatever context they 
wish.  Period.


Nicolas
--8323328-845050105-1296590771=:8580--
