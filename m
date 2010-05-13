Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab0EMOhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:37:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab0EMOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:37:42 -0400
Date: Thu, 13 May 2010 07:35:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <20100513075728.GF30110@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Dmitry Torokhov wrote:
> 
> Bastien Nocera (1):
>       Input: i8042 - do not try to probe ports on Intel Apple Macs

I pulled, but I skipped the last commit, because I think this one is 
fundamentally _wrong_.

It is _not_ maintainable to create random tables of exceptions ("DMI 
tables"), and it's actively _wrong_ to do for something like this where we 
not only have historically worked perfectly well, and this apparently 
tries to hide some other bug (the commit says "could potentially lock 
up/hang/wait for timeout for long periods of time").

We should fix the problems instead of hiding them for specific machines. 
Does anybody really think that Apple machines are the only ones with no 
legacy keyboard? Hello? Does anybody seriously think that it's ok to add 
entries to DMI tables for random new machines coming out?

So I think that commit was (a) totally inappropriate to send at this point 
in the late -rc series _anyway_ (it sure as hell isn't a refression fix), 
and that makes me wonder about the other ones. But (b) I don't think I 
want to ever see anything like that during a merge window either, because 
it's quite seriously the wrong thing to do.

What are the _actual_ problems on legacy-free machines? And keep in mind 
that I ask that exactly because I actually _have_ two Apple Mac Mini's in 
my household, and have never seen any problems with keyboard/mouse 
handling. 

So if somebody saw "could potentially lock up/hang/wait" issues, then 
dangit, say what those issues are, AND LET'S FIX THEM! And not like this, 
trying to hide them for some particular machines, rather than fixing the 
actual underlying detection bug.

			Linus
