Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1HOPYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:24:41 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:16632 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1HOPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:24:38 -0400
Date: Mon, 15 Aug 2011 17:24:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Josip Rodin <joy@entuzijast.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH,SPARC] make sparc32 arch_write_unlock() match the
	sparc64 version
Message-ID: <20110815152436.GA31355@merkur.ravnborg.org>
References: <20040.65109.439941.444670@pilspetsen.it.uu.se> <20110815133116.GA20563@entuzijast.net> <20041.11793.565236.115039@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20041.11793.565236.115039@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael.

>  > > @@ -175,7 +184,7 @@ static inline int __arch_read_trylock(ar
>  > >  	res; \
>  > >  })
>  > >  
>  > > -#define arch_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
>  > > +#define arch_write_unlock(rw)	arch_write_unlock(rw)
>  > >  
>  > >  #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
>  > >  #define arch_read_lock_flags(rw, flags)   arch_read_lock(rw)
>  > 
>  > Why keep the tautological define? Just wondering.
> 
> Only because sparc64 does it that way.  I now see that no other
> arch has the #define, so perhaps that bit should be deleted (from
> both sparc64 and sparc32).
Please kill the extra define in both sparc32 and sparc64.
Preferably in two separate patches.

For the subject of the patch please use:
[PATCH] sparc32: bla bla

Because when davem apply the patch everything in [] is zapped,
and it is good to see in the shortlog that this is a sparc32 specific patch.

For sparc64 we sometimes use "sparc64: bla bal", and sometimes use
"sparc: bla bla".
I prefer the first but no strong feelings.

And btw thanks for looking at this! Looks like a very difficult bug to nail.

	Sam
