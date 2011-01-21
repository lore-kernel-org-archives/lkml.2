Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1AUJct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:32:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51653 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1AUJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:32:48 -0500
Date: Fri, 21 Jan 2011 09:32:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Dima Zavin <dmitriyz@google.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110121093218.GB13235@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org> <4D3862DB.5000708@fluff.org> <20110120185617.GI6335@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1101201623480.8580@xanadu.home> <AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com> <4D3907BD.4040900@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3907BD.4040900@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 08:12:45PM -0800, Saravana Kannan wrote:
> In my opinion, the only major reason for needing atomic clk APIs was due  
> to device_ops->suspend being atomic. Since that's not the case anymore,  
> I really don't see a justification for atomic clocks. Sure, I might have  
> missed some exceptions, but in that case we should make the atomic APIs  
> an exception (add clk_enable_atomic) and not the norm.

The suspend method has never been atomic.  It has always been able to
sleep.  You're mistaken.
