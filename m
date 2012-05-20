Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2ETXgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 19:36:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33038 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2ETXgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 19:36:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205201333210.10189@chino.kir.corp.google.com>
References: <20120518212656.GA4992@kroah.com> <20120519010105.GB18264@home.goodmis.org>
 <20120519042038.GB11939@kroah.com> <1337479307.32434.16.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1205191930310.24674@chino.kir.corp.google.com>
 <CA+55aFwGpDtMR=8GfDqyZGdw_pQFxG-EL15LaNm0wVoXZChXSA@mail.gmail.com> <alpine.DEB.2.00.1205201333210.10189@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 May 2012 16:35:57 -0700
X-Google-Sender-Auth: d4MACWQ5oMICqKfRyvOfXcRf3UU
Message-ID: <CA+55aFw3f1ru3A78ycaZj8nPMR8s5cfLvNcRBg761M7Losn6qw@mail.gmail.com>
Subject: Re: [PATCH] pidmap: Use GFP_ATOMIC to allocate page (was: Re: [
 00/54] 3.0.32-stable review)
To: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 4:22 PM, David Rientjes <rientjes@google.com> wrote:
>
> I think this may be unnecessarily too late; smp_init() will rely on the
> arch-dependent cpu_up to guarantee that cpu_idle() has been called and
> sched_init_smp() seems to think we can do GFP_KERNEL.

Well, yes, we can pretty much rely on scheduling having to work at the
top of kernel_init(), since kernel_init is being run in a new thread
(and thus must have scheduled from the original thread that becomes
the first idle thread).

But I thought we might as well delay it until the system was really
up, since I wasn't entirely sure what the heck the other CPU's might
be doing. That said, I don't really care deeply, I think that anywhere
in kernel_init should be fine.  I have no strong opinions, but the
current location does seem buggy.

That said, I'm not going to delay 3.4 over this (in fact, I already
tagged it locally, but haven't pushed out yet because the back-end
kernel.org machines seem to be unreachable right now). It apparently
only matters for configurations that are not really all that
realistic.

                             Linus
