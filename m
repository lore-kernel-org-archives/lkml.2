Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0DOXLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:11:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57238 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab0DOXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NjpNqkR+TCqswns1HQkw4kdiRMTK+8+Mf/4kztSBEZ0N6Z6PKv36/Pgyc0a4GK/aja
         L+E6CJ0MsXxQTPCI8VVEBAG761gHABPW+OpBT+vbcJjoJO24dd/C60xmfANq8KH94or1
         QyHzXltmJXUmxjLkP4wWuBSgo0cYldmrABm0U=
Date: Fri, 16 Apr 2010 01:10:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chase Douglas <chase.douglas@canonical.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
Message-ID: <20100415231052.GA15570@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com> <1271262016-18650-3-git-send-email-chase.douglas@canonical.com> <20100415210357.GG5069@nowhere> <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com> <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:01:50AM +0200, Thomas Gleixner wrote:
> > I tend to think of the TRACE_EVENT_* as an indication of severity and
> > whether we want to stop the trace by default. From a distro
> > standpoint, the likelihood that we want to continue tracing after a
> > __schedule_bug is pretty low. It's easiest if we don't have to tell
> 
> Well, scheduling while atomic is a BUG, but one of the category which
> allows the kernel to continue. So in fact it's treated like a WARN_ON.
> So the tracing_off_event() qualifier should be *_WARN.
> 
> That's independent of the question whether you want to stop tracing in
> that very case


Exactly.

