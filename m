Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab0DPBtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 21:49:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49629 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab0DPBtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 21:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JA/IIhxmX6Mzck4ey37fGMBpUSTGMrLPmWcb69zJAWFOtQdJAdqIqCD1cW2P2y8dKp
         WikU+/xtwUEV8YLrG5fDsEeNjzpKWpWu78q4OA0MWpaFUSwG4sgystlNetpgBW1AZK9+
         tKgdKLAGqDdiRVt/ZuHZmJ1filXTy7AlBO+Eo=
Date: Fri, 16 Apr 2010 03:49:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chase Douglas <chase.douglas@canonical.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
Message-ID: <20100416014937.GD15570@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com> <1271262016-18650-3-git-send-email-chase.douglas@canonical.com> <20100415210357.GG5069@nowhere> <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com> <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain> <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com> <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain> <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 02:21:47AM +0200, Thomas Gleixner wrote:
> On Fri, 16 Apr 2010, Thomas Gleixner wrote:
> > BTW, if interacting with grub is that hard: how does an user start the
> > tracer at all ?
> 
> Just looked through the other patches and noticed that the patch which
> provides the tracing_off(level) stuff is incomplete as it provides
> only a command line option to change that tracing off level.
> 
> The command line option is merily for tracing which happens to be
> started on the command line i.e. _BEFORE_ we have usable user space.
> 
> So your grub argument is just crap. If the user cannot change this
> setting w/o fiddling with the obscured grub then he can not start the
> tracer on the command line either.
> 
> But somehow he can start the tracer later when user space is up and
> running, but there is no way to change that setting anymore. Therefor
> you go through the kernel and impose settings at will.
> 
> 1) Your patch simply lacks an interface to change that setting via
>    debugfs/tracing/wtf
> 
>    WTF should I reboot my machine to change that setting from the
>    default BUG to WARN or NONE ? There is no reason at all.
> 
> 2) tracing off can be done via filters on functions and/or events
>    already - so I doubt that the tracing_off_event(level) is necessary
>    at all.



Yeah it works for the function tracer, but not for events (or other tracers),
or I missed this feature somehow.

