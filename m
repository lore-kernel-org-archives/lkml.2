Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2EAMYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:24:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab2EAMX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:23:59 -0400
Date: Tue, 1 May 2012 14:23:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
In-Reply-To: <alpine.LNX.2.00.1204301350540.1856@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1205011423130.1856@pobox.suse.cz>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1204301032410.1856@pobox.suse.cz> <alpine.LNX.2.00.1204301043340.1856@pobox.suse.cz> <20120430115302.GA2847@polaris.bitmath.org>
 <alpine.LNX.2.00.1204301350540.1856@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Jiri Kosina wrote:

> > Ah, yes. I take it you are talking about tty/vt/keyboard.c. So some
> > random keypress during shutdown triggers the event, which eventually
> > reaches input_pass_event(). From there on, the trace stays in the
> > mentioned driver. First kbd_event() gets called, which takes the lock
> > and goes on to, in turn, call kbd_keycode(), k_handler[2]() ==
> > k_spec(), fn_handler[9]() == fn_hold(), which goes on to call
> > stop_tty(). This function comes back to the driver, via con_stop(), as
> > vt_kbd_con_stop(), which in turn takes the same lock. So unless the
> > teardown of something in hid affects the choices made in the tty
> > driver, it appears this is a different problem. Or?
> 
> I just came to the same conclusion a few minutes ago ... i.e. this is 
> likely unrelated to the patchset and I just triggered it by pure 
> coincidence on the patched kernel.
> 
> I will keep looking into it a little bit more. Dmitry, any immediate ideas 
> by any chance?

Okay, someone was able to get lockdep complain about this and Alan is 
apparently on it already:

	https://lkml.org/lkml/2012/5/1/69

So nothing to be worried about.

-- 
Jiri Kosina
SUSE Labs
