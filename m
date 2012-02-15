Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab2BOWTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:19:43 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:43071 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BOWTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:19:42 -0500
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jack Stone <jwjstone@fastmail.fm>,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        gregkh@linuxfoundation.org
Subject: Re: Deadlock?
Date: Wed, 15 Feb 2012 12:42:45 +0100
Message-ID: <20459834.QRhKtMFN8x@f209>
User-Agent: KMail/4.8.0 (Linux/3.2.4-gentoo; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120214124735.GD1934@quack.suse.cz>
References: <3125411.WeeEOF8PnR@f209> <4F394A5E.4050002@fastmail.fm> <20120214124735.GD1934@quack.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hYTPT7U5IYFm8qLWuaWnd8rjAx+GtRR0dfERhSfHXus
 ejUZOuUVXa5MylAXv+QxdWU7bIeBqoRoBwu9zfYV3QOgC9gCkP
 LBQwW0RjWK+H0CuAGhlYr2r/yvKFZn3YV5ga92Z0psJSzjO7v2
 U9Y0ovTOyBRdXDVfQvTzMayOpkkDgxUZtoTlr1yGXIzrvTMcV8
 hySiHbXE90fkr3e+RyJuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

/proc/sysrq-trigger does not exists, I will apply the patch and enable sysrq.
But it may take some days for a result.

Thanks,
Markus

Jan Kara schrieb am 14.02.2012:
> On Mon 13-02-12 17:37:34, Jack Stone wrote:
> > Adding CCs
> > 
> > On 02/13/2012 11:17 AM, Markus wrote:
> > > I noted some kind of deadlock, where I was not able to write to the raid6, 
> > > while writing to each disk would still work.
> > > This caused many processes to "wait" in d-state, thus making it impossible to 
> > > unmount, cleanly reboot, sync, ...
>   Thanks for report. Could you please provide output of
>     'echo w >/proc/sysrq-trigger'
> in dmesg? That would help us narrow down the real cause the the current
> deadlock.
> 
> > > So I enabled the detection of hung tasks and this deplock option.
> > > After running a 3.2.2 for about 5 days:
> > > http://pastebin.com/gy1kaYmS
> > > 
> > > I dont know if its a bug or nothing. Or if it has anything to do with my 
> > > problem as there was no hungtask detected and the raid still seems to work.
>   It's lock debugging code complaining about a possible problem it found.
> Actually, the problem looks real (although hard to hit AFAICS) and attached
> patch should fix it. Does the patch fix things for you? If not, please
> provide the output I describe above.
> 
> 									Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
