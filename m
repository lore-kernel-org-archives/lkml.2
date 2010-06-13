Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0FMWZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 18:25:33 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:28348 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753219Ab0FMWZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 18:25:32 -0400
Date: Sun, 13 Jun 2010 23:25:12 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Lothar Wa?mann <LW@KARO-electronics.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Ben Dooks <ben-linux@fluff.org>,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100613222512.GE31045@fluff.org.uk>
References: <1275636608.606606.450179637764.0.gpush@pororo>
 <1275636608.607067.417709988883.1.gpush@pororo>
 <20100611042046.GA31045@fluff.org.uk>
 <201006111557.12249.jeremy.kerr@canonical.com>
 <19473.61547.684572.647641@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19473.61547.684572.647641@ipc1.ka-ro>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 10:14:35AM +0200, Lothar Wa?mann wrote:
> Hi,
> 
> > > > +static inline int clk_enable(struct clk *clk)
> > > > +{
> > > > +	int ret = 0;
> > > > +
> > > > +	if (!clk->ops->enable)
> > > > +		return 0;
> > > > +
> > > > +	mutex_lock(&clk->mutex);
> > > > +	if (!clk->enable_count)
> > > > +		ret = clk->ops->enable(clk);
> > > > +
> > > > +	if (!ret)
> > > > +		clk->enable_count++;
> > > > +	mutex_unlock(&clk->mutex);
> > > > +
> > > > +	return ret;
> > > > +}
> > > 
> Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> makes it impossible to call those functions in interrupt context.

I think that is a bad idea, unless you can provide otherwise. These
calls can sleep depending on implementation, and thus I would like to
ensure that they are marked as might-sleep.

Is there any specific reason? If so, we need to add some form of ops
where we have _nosleep specificially for this case.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
