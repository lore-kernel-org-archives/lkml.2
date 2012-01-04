Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2ADSoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:44:04 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47204 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2ADSoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:44:01 -0500
Message-ID: <4F049DEA.30506@suse.cz>
Date: Wed, 04 Jan 2012 19:43:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: serial ports now asserting DTR and RTS during boot; breaks connected
 hardware
References: <20120103153707.GA12771@redhat.com> <4F03262D.8090506@suse.cz> <20120103161310.GA8727@redhat.com>
In-Reply-To: <20120103161310.GA8727@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2012 05:13 PM, Dave Jones wrote:
> On Tue, Jan 03, 2012 at 05:00:45PM +0100, Jiri Slaby wrote:
>  > On 01/03/2012 04:37 PM, Dave Jones wrote:
>  > > Jiri,
>  > > We got this report from a user who notes a change in behaviour for
>  > > his serial hardware over the last few kernel versions.
>  > 
>  > Hi!
>  > 
>  > I'm busy right now, however just after a quick look, it may be related to:
>  > https://lkml.org/lkml/2011/12/6/573
>  > 
>  > I'll take a look later.
> 
> thanks. I'll dig a little deeper. 
> 
>  > > https://bugzilla.redhat.com/show_bug.cgi?id=771010
>  > > 
>  > > This sounds like it might be related to your DTR/RTS changes back in March 2011 maybe ? 
>  > 
>  > What changes do you mean? In serial-core.c? Thaat one is not used by USB
>  > serials. Hence this wouldn't occur with FTDI.
> 
> yeah, 303a7a1199c20f7c9452f024a6e17bf348b6b398 and c7d7abff40c27f82fe78b1091ab3fad69b2546f9
> jumped out at me, as they were they only things that changed DTR/RTS handling
> (at least mentioned in changelog) in recent times.

Rollback. The two commits are about uart. So they don't as well affect FTDI.

> The user mentions that it also affects 8250, though your point may mean
> that this is caused by something further up in the serial/tty code.

Or userspace. Try what Alan suggested. And ensure that FTDI is really
affected. Sometimes bug reporters do mistakes.

-- 
js
suse labs
