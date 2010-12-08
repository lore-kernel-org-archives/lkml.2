Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0LHIvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:51:54 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:60702 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab0LHIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:51:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mO+SK3reFwQyCdHG5VUxEkvo7guyIyWf9GUxIff+0jy7on0xB8bKX8ghTlE+d+O8KX
         M08a/wbKKr0QmtkfZasSQL1VUev3aLN61BwFhddJzTeArLF7iLDFx/IvwRE7Mxbcx/Pl
         dVjTR/8aLCa7dFwUhROY1qcTngVeJuEI7nEU0=
Date: Wed, 8 Dec 2010 10:51:45 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jesper Juhl <jj@chaosbits.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/45] kstrtox: converting strings to integers done
 (hopefully) right
Message-ID: <20101208085145.GA5320@core2.telecom.by>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
 <201012071004.58311.arnd@arndb.de>
 <20101207093229.GB29776@core2.telecom.by>
 <201012071045.33870.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012071045.33870.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 10:45:33AM +0100, Arnd Bergmann wrote:
> On Tuesday 07 December 2010 10:32:29 Alexey Dobriyan wrote:
> > On Tue, Dec 07, 2010 at 10:04:58AM +0100, Arnd Bergmann wrote:
> > > On Monday 06 December 2010 16:16:36 Alexey Dobriyan wrote:
> > >
> > > > It is used by kstrtol() if "long" and "long long" aren't the same type.
> > > > I can't ifdef it because gcc doesn't allow "#if sizeof(long long) == ".
> > > > "Do not use" hints "use kstrtol()".
> > > 
> > > Can't you use #ifdef CONFIG_64BIT to see if long is 64 bit wide?
> > 
> > I could, but there are no defines for alignment.
> 
> Not sure what you mean here.

One can't write:

	#if sizeof(long) == sizeof(long long) && alignof(long) == alignof(long long)

and there are no _ALIGNOF_LONG or something like that.

> All architectures always naturally align 'long' variables --
> we rely on that elsewhere already. 'long long' is misaligned on x86-32 and
> possibly some other 32 bit architectures, but since that should not cause
> any problems.

The point is that code as written doesn't care and correct wrt alignment.

> Another option would be to export just the strto{u,s}{8,16,32,64}
> functions and define the inline wrappers conditionally on CONFIG_64BIT.

This means more ifdefs. Maybe someone could ifdeflessly fix this later.
