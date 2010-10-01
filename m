Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0JABA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:00:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab0JABAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:00:25 -0400
Date: Thu, 30 Sep 2010 18:01:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        heukelum@fastmail.fm, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
Message-Id: <20100930180100.4607034f.akpm@linux-foundation.org>
In-Reply-To: <4CA52AA5.5040402@zytor.com>
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org>
	<4C91F07E0200007800016B50@vpn.id2.novell.com>
	<20100916082816.GA25681@elte.hu>
	<4C91F3A30200007800016B64@vpn.id2.novell.com>
	<20100916101355.GA31458@elte.hu>
	<4C9219BC0200007800016C53@vpn.id2.novell.com>
	<4CA52AA5.5040402@zytor.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 17:26:13 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 09/16/2010 04:21 AM, Jan Beulich wrote:
> >>
> >> Yes, to only generate CFI on binutils that allows us to write sane 
> >> looking code.
> >>
> >> I.e. to disable CONFIG_AS_CFI on binutils that are broken for this.
> > 
> > Again - that won't help, as it's the macro invocation that gas
> > fails one, not one of the actual .cfi_* directives.
> > 
> 
> Looking again at this issue with the binutils version from hell
> (sigh)... I'm running quickly out of ideas.
> 
> The problem is that cpp inserts spaces around expansions, so:
> 
> 	pushq_cfi $(USER_DS)
> 
> ... turns into something like ...
> 
> 	pushq_cfi $( ( 5 * 8 + 3 ) )
> 
> ... which these old versions of gas considers multiple arguments to the
> macro, even though there is no comma anywhere.

Could we run another little program after cpp which takes the spaces
out again?

