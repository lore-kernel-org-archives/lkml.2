Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1BTNN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:13:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36775 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1BTNN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:13:56 -0500
Date: Sun, 20 Feb 2011 13:13:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110220131309.GF14495@n2100.arm.linux.org.uk>
References: <1297233693.242364.862698430999.1.gpush@pororo> <4D53749B.6010102@codeaurora.org> <201102151041.40655.jeremy.kerr@canonical.com> <4D5A100F.9000809@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5A100F.9000809@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 09:33:03PM -0800, Saravana Kannan wrote:
> Assuming Russell and/or the community agrees on the semantics of  
> "parent", without the generic implementation grabbing the prepare_lock  
> while setting the parent, there is no way for the specific clock driver  
> implementations to cleanly ensure correctness. The only option for them  
> would be to peek into the generic clock struct and grab the prepare lock  
> -- to me that would be an ugly hack and/or layering violation that would  
> cause problems later on.
>
> Russell/All,
>
> What's the meaning of a parent clock? Do you agree with my definition --  
> "the parent clock is the clock that generates the clock signal from  
> which the child clock derives (divide, etc) it's clock signal from."? Or  
> is it open to interpretation by each implementation?

Your definition seems sane - I'm not sure what use a parent clock which
had nothing to do with a child would be.

As for the locking issue, I've no idea on that at the moment.  I don't
think implementations should grab the prepare lock, I think that's
something the generic code should take care of for clk_set_rate(),
clk_set_parent() etc.
