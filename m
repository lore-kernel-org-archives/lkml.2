Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab0FBT4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:56:51 -0400
Received: from usul.saidi.cx ([204.11.33.34]:48425 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932897Ab0FBT4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:56:49 -0400
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: strange problem with ricoh-mmc
MIME-Version: 1.0
Date: Wed, 02 Jun 2010 15:54:20 -0400
From: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1275505018.4215.10.camel@maxim-laptop>
References: <1275505018.4215.10.camel@maxim-laptop>
Message-ID: <04b98a3f757587ee9b72f2e28e257b50@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 02 Jun 2010 21:56:58 +0300, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> Hi,
> 
> Maybe this is my fault, don't know, but I found and now confident that
> new and possible old version of ricoh-mmc causes troubles after
> suspend/resume.
> 
> Namely there are two problems.
> One is that sometimes card detection on xD controller stops working.
> That is it doesn't respond to insert/remove events, and suspend to ram
> just updates that once. Granted I wrote this driver, but it appears to
> work without richoh-mmc.
> 
> Another problem that is unrelated to xD is that sometimes sdhci
> conroller issues an interrupt storm, and does so until its driver is
> reloaded. At that point it refuses to load with missing voltage levels.
> 
> I never seen these without ricoh-mmc pci quirk.
> 
> Both problems are semi-rare.
> 
> So just one question, did you see these problems?
> Do you have a clue on how to proceed?

I have never seen these problems, but I could imagine that perhaps the
PCI register pokes have side-effects or there's actually more that needs
to be done than what we currently have. No one has access to the relevant
datasheets so the magic incantations are second hand. More worryingly, it
may not be a well supported configuration - while the other controllers
might be disabled based on physical slot design, SD and MMC are the same,
so I doubt Ricoh or OEMs have ever seriously considered having only one
on. I've not heard of the sdhci problem before - maybe your hardware is
dodgy? :-)

--phil
