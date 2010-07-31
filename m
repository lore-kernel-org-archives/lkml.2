Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0GaSTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 14:19:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48361 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0GaSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 14:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V6CTC4Bbqs0QvtI49yr63bhJSJ7Ni3vhDKFoEQK0lbxFx1ze0bPWz6XBv/SvKhtwGV
         VpOoToCz61GB2yKbnLEXhOg+4PsTWrRy+ujCKycRfQYJXkrZU1nI3Ie5II5GK9OhUHhB
         GdvwthOHy+t86das97Q16SKgTr+ZxvBwOQnck=
Date: Sat, 31 Jul 2010 22:18:45 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: Andi Kleen <ak@linux.intel.com>, kernel-janitors@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
Message-ID: <20100731181845.GB9378@albatros>
References: <1280335185-23265-1-git-send-email-segooon@gmail.com>
 <4C5063D4.4070108@linux.intel.com>
 <20100728171327.GA24149@albatros>
 <4C5066CB.7010009@linux.intel.com>
 <20100729093511.GB7143@albatros>
 <4C514F04.80603@linux.intel.com>
 <4C51538C.1090803@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C51538C.1090803@bfs.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 12:10 +0200, walter harms wrote:
> 
> 
> Andi Kleen schrieb:
> > 
> >> IMO memmory allocation fails are dangerous in kernel mode. As it is
> >> probably not exploitable because of boot time, it can destroy some
> >> sensitive data like dirty disk caches those are going to be written on
> >> disk.
> > 
> > It's true for runtime, but not for normal boot time.
> > 
> > Anyways if it happens on boot time the only thing you can do is panic,
> > but someone else
> > will likely panic anyways for you. Just ignoring it like your patch
> > effectively does
> > (because nothing will ever look at the ENOMEMs for an initcall) is wrong
> > though
> > In this case it's actually better to oops like the original code does.
> > 
> > BTW even with your patch likely later code will crash anyways because it
> > doesn't
> > expect init code to fail.
> > 
> 
> NTL it is nice to have a error message. for users it is worse if you crash suddenly
> with out warning than having a crash with "OOM" before because it gives you a clue
> what is going on.
> short:
> please think of users that are not kernel developers give them a hint what went wrong.
> 
> to make thinks more easy on boot we could replace kalloc() with kmalloc_or_die().
The thing is that this driver does not call kmalloc() explicitly, it
uses function those call functions those call kmalloc() :)

If we call BUG_ON() in init code, it would not make big overhead and
would make fault exactly when bug was detected, independent from caller
checks. Andi, are you fine with it?

> When anyone runs out of mem on boottime you can panic() instantly.
> 
> just my to cents,
>  wh
> 
