Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0CSSD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:03:28 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43469 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0CSSD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JMWCIbVZ5YWyA3j7GVta76XxBqFU9Aj8TjaFTeY44XNj5apUIRkfLHyjFS+IffdRG7
         bSq8WxawJ7zzmeHoTbNwNKG21VU3CU8jzPIr0FKhklqLc5Q1WZTBrNvVB8688In3C9Gp
         J+Ig3M2XORBmTxN63TeeuVDI+e9pk69oSGSTA=
Date: Fri, 19 Mar 2010 11:03:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100319180314.GB12143@core.coreip.homeip.net>
References: <20100317061952.GA19789@core.coreip.homeip.net>
 <20100319000043.GC12017@khazad-dum.debian.net>
 <20100319000931.GA5671@core.coreip.homeip.net>
 <20100319160641.GC16743@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319160641.GC16743@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 01:06:41PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Mar 2010, Dmitry Torokhov wrote:
> > On Thu, Mar 18, 2010 at 09:00:43PM -0300, Henrique de Moraes Holschuh wrote:
> > > Any chance of the user being able to avoid the SysRQ events getting to the
> > > handle, e.g. by opening the input device in exclusive mode or something like
> > > that?
> > 
> > Yes, it is a possible to suppress SysRq by grabbing an input device.
> > This possibility exisst with the current implementation too though -
> > after all legacy keyboard driver implemented as an input handler as
> > well.
> > 
> > ... or am I answering a question different from the one you asked? ;)
> 
> No, that's exactly what I wanted to know.
> 
> What about SAK?  That thing *has* to be untrappable.
> 

On what level untrapable? And what exactly is SAK? There is not a
special key, at least not in general case, it is an action assigned to a
key comboi.  Root can "trap" legacy keyboard SAK with loadkeys; it can
also disable sysrq, unload modules and do other nasty things. But
ordinary users can not trap it.

> Even for the SysRQ debug events, I'd feel better if we could have a class of
> system input handlers that cannot be suppressed to use for these things.

That would require moving "these things", including their state
machines, into input core otherwise it would not know what events can be
trappable and which should be passed through. Or we should get rid of
EVIOCGRAB.

Given the fact that event devices are accessible only to root I think
that current behavior is acceptable.

-- 
Dmitry
