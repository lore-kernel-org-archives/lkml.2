Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0ETQgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:36:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:43834 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab0ETQgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:36:13 -0400
Date: Thu, 20 May 2010 18:36:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Prince <dhprince-devel@yahoo.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] HID
In-Reply-To: <alpine.LFD.2.00.1005200922020.23538@i5.linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1005201834190.28092@pobox.suse.cz>
References: <alpine.LNX.2.00.1005191430370.28092@pobox.suse.cz> <alpine.LFD.2.00.1005200912540.23538@i5.linux-foundation.org> <alpine.LFD.2.00.1005200922020.23538@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Linus Torvalds wrote:

> Oh, and I notice that I shouldn't blame Don - this kind of crap is 
> apparently de rigeur in the HID layer. I only noticed because this time it 
> was a clearly very specialized driver and I started wondering what that 
> odd name was.
> 
> Guys, I can understand it if it's some kind of big-name "exists 
> everywhere" thing. Doing it for big vendors like Logitech devices may make 
> sense. But don't do it for random specialized hardware. 

Well, this is basically because of your request you made 1.5 years ago.

Originally, all the quirks were sprinkled all over the generic code, 
making it unmaintainable mess. Then the quirks for paricular 
devices/device groups were separated into idividual drivers, which meant 
quite a few new config options.

When I sent you pull request with this back then, you responded with

==
As to the Kconfig options - do they really add so much space that you need 
to ask for the quirks? You didn't use to. Can you make the questions 
depend on EMBEDDED, or at least on the HID_COMPAT thing or whatever?
==

Since then, I am keeping it organized in a way that drivers, which are 
really simple, trivial and small workarounds (descriptor/parser fixes), 
are selected in 'EMBEDDED'-way automatically.

Other larger drivers, which actually implement something substantial and 
have non-trivial code size impact, are added as a normal config options.

As all this EMBEDDED handling as been initially introduced on your 
request, I am perfectly fine removing it if you don't like it anymore.

> At least ask the user "Do you want to support all the HID crap in the 
> universe" to allow people to say Yes/No once (instead of for every 
> single crazy device).

That's definitely also an option. Do you want me to redo it this way 
before you'll be pulling it?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
