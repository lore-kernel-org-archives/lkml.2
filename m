Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab0FNWVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:21:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60740 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0FNWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:21:11 -0400
Date: Mon, 14 Jun 2010 18:21:07 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Matt Fleming <matt@console-pimps.org>
cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Michal Marek <mmarek@suse.cz>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
In-Reply-To: <87y6ehxvby.fsf@linux-g6p1.site>
Message-ID: <alpine.DEB.1.10.1006141534490.1248@dr-wily.mit.edu>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org> <alpine.DEB.1.10.1006141014360.1432@dr-wily.mit.edu> <87y6ehxvby.fsf@linux-g6p1.site>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Matt Fleming wrote:

> Do these special kernel sections include things like the parisc
> .text.do_softirq, .text.sys_exit, etc? James raised a good objection to
> the parisc patch of this series. I'm guessing most people saw it already
> but I'll paste it here for reference,
> 
>     This would destroy all of the named parisc text ordering we do above the
>     removed line because now you'd have swept up all the function sections
>     before we get to them, won't it?
> 
>     The ordering is an execution speed up on 32 bit systems because our
>     relative jump is so short.
> 
> Will you changes handle this OK?

I think I addressed this in my reply to James just now, but to be super 
clear, this -ffunction-sections plan involves renaming .text.do_softirq to 
.text..do_softirq (etc.) first.

	-Tim Abbott
