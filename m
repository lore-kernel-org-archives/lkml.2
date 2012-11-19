Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2KSRIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:08:45 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37696 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2KSRIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:08:44 -0500
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.39.152
Date: Mon, 19 Nov 2012 09:08:37 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/58] x86: arch/x86/kernel/irqinit.c: Add prototype for
 init_IRQ
Message-ID: <20121119170837.GA2882@jtriplet-mobl1>
References: <1353302917-13995-47-git-send-email-josh@joshtriplett.org>
 <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
 <22709.1353321377@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22709.1353321377@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 10:36:17AM +0000, David Howells wrote:
> Josh Triplett <josh@joshtriplett.org> wrote:
> > arch/x86/kernel/irqinit.c defines an __init function init_IRQ, called
> > from init/main.c.  No header file prototypes init_IRQ, because
> > init/main.c tends to directly define prototypes for init functions it
> > calls, rather than including appropriate headers.  So, add a prototype
> > of init_IRQ to arch/x86/kernel/irqinit.c right above the definition, to
> > satisfy gcc (-Wmissing-prototypes) and Sparse (-Wdecl).
> 
> Rather, you should put a declaration for it in a header file.

Happy to do so, except that as far as I can tell it doesn't seem
appropriate for any existing header, and creating a new header for the
sole purpose of that one prototype seems excessive, particularly since
the function only has the one call from init/main.c.  Nonetheless, if
you'd like a new header created for that prototype, or you have a
suggestion for an existing header I missed that seems appropriate, let
me know and I'll respin the patch.

- Josh Triplett
