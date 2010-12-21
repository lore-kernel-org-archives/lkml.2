Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab0LUBk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:40:26 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:51313 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933396Ab0LUBkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:40:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nFKM9pPhJHx6O//AJFCktKBas/RxcC0zqdfYsb1FGEmV6IDtIXlR4zPlIce4gJhsUD
         dr2lOZ9jFiyZhCyuRp+/58ZTVGCb14FSL9HnL/H6Bd5ep2MdGk5zasa4hxd8WXgXdqKX
         m5TOkZ6xCkJAEKXZ8Dnhq6h2tyorVoKOo7cmQ=
Date: Tue, 21 Dec 2010 02:40:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 12/15] clocksource: Ignore nohz task cpu in
 clocksource watchdog
Message-ID: <20101221014019.GM1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-13-git-send-email-fweisbec@gmail.com>
 <1292862458.5021.39.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292862458.5021.39.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:27:38PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > 
> > The watchdog should probably make an exception for nohz task cpus
> > that want to be interrupted the least possible.
> > 
> > However we probably need to warn the user about that.
> > 
> > Another solution would be to make this timer defferable.
> 
> Nah, both skipping a cpu and making the timer deferrable render the
> watchdog useless, just disable the thing.

Thomas seemed to prefer we keep it but just ignore the nohz task cpus
I mean when we talked about that at that time, the notion of nohz was
purely per cpu.

Now we wish the notion of nohz task cpu could disappear, so
we should indeed deactivate the thing for that config.

Would be nice to have Thomas opinion too.
