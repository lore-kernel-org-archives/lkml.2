Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1BJNOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:14:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36594 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1BJNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:14:39 -0500
Date: Thu, 10 Feb 2011 13:13:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Zhao <linuxzsc@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Richard Zhao <richard.zhao@freescale.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110210131308.GB1742@n2100.arm.linux.org.uk>
References: <1297233693.242364.862698430999.1.gpush@pororo> <4D52F73A.4010707@bluewatersys.com> <20110210100319.GB24710@b20223-02.ap.freescale.net> <20110210104639.GZ27982@pengutronix.de> <20110210130800.GB3316@richard-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210130800.GB3316@richard-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 09:08:00PM +0800, Richard Zhao wrote:
> Why? what restriction will it cause to add parent in clk?
> Two benifits at least I can see:
> 1. null ops handle, as I said above.
> 2. export clock tree to user level for debug. It's very helpfull.

Don't be tempted to expand what's done at the generic level.  Platforms
may need special handling at the current clock level before the parent
clock level is considered.  Also platforms may not have parents so it
becomes mere bloat.

The more complicated the generic level becomes, the more platforms won't
covert to it.
