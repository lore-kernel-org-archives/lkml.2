Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0EGCgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:36:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab0EGCgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:36:02 -0400
Date: Thu, 6 May 2010 19:34:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
In-Reply-To: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 May 2010, Len Brown wrote:
> 
> The big DMI list in sleep.c a temporary brute force and low-risk workaround.
> We will endeavor to delete it entirely in 2.6.35 with a clean fix
> that was deemed too risky for this late in the .34 release cycle.

Btw, why don't we just force the SCI_EN by hand?

We did that for the Apple Mac Mini bug too. It was always the right thing 
to do.

There is _no_ reason not to force it. If the BIOS set it, it's a no-op. If 
the BIOS didn't set it, it's a bug that _must_ be fixed.

I really don't see the reason for that DMI list. What could _possibly_ go 
wrong for just setting the damn bit that we _know_ has to be set?

How could setting SCI_EN _ever_ be a bug? Seriously? Why are we doing this 
conditionally, especially considering that even the commit message here 
explicitly states that Windows does it unconditionally?

And no, I'm not interested in "that toilet paper spec says you can't touch 
it". I care about _reality_.

				Linus
