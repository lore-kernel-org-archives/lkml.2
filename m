Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0FXNBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:01:37 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:35433 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810Ab0FXNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:01:26 -0400
Date: Thu, 24 Jun 2010 18:31:09 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 6/6 V4] input: STMPE touch controller support
Message-ID: <20100624130108.GE26189@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
 <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
 <20100624123153.GB26189@bnru02.bnr.st.com>
 <20100624124210.GC3988@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100624124210.GC3988@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 14:42:10 +0200, Luotao Fu wrote:
> On Thu, Jun 24, 2010 at 06:01:53PM +0530, Rabin VINCENT wrote:
> > On Thu, Jun 24, 2010 at 13:13:41 +0200, Luotao Fu wrote:
> > > +       ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_FRACTION_Z,
> > > +                       FRACTION_Z(ts->fraction_z),
> > > +                       FRACTION_Z(ts->fraction_z));
> > 
> > I think your earlier revisions had this same behaviour, but this only
> > writes the bits you are trying to set, and it may be a problem if there
> > are other bits already set in this field.  I don't know if this is a
> > concern with this block, but if it is, you can do something like the
> > following to clear out the field before writing:
> > 
> 
> This is done intentionally to leave the bits alone which I don't want.
> Most of the registers here are used exclusively for the touchscreen.
> Some others are shared with the ADC. The ADC however doesn't have any
> own configuration and has to go with the configuration of the touch
> screen. Hence it's OK, even probably better not to touch the bits we
> don't need.

I meant something like: let's say you want to change the "count of the
fractional part" (I quote from your platdata).  It (the FRACTION_Z
field, I assume) has a default value of (say) 2.  Say you want to change
the count to 1.  The above write will change it to 3 instead.  If this
is really the behaviour you need, it should be OK then.

Rabin
