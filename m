Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966032Ab2JZSgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:36:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53969 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965944Ab2JZSgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:36:03 -0400
Date: Fri, 26 Oct 2012 19:36:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: P J P <ppandit@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
Message-ID: <20121026183601.GR2616@ZenIV.linux.org.uk>
References: <20121024232032.GA31129@www.outflux.net>
 <20121025041620.GH2616@ZenIV.linux.org.uk>
 <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
 <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
 <20121025120952.GI2616@ZenIV.linux.org.uk>
 <20121025123843.GJ2616@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:08:20PM +0530, P J P wrote:
> +-- On Thu, 25 Oct 2012, Al Viro wrote --+
> | 	* every bleeding script will have bogus execution of modprobe done
> | at execve time (and you'd better pray that /sbin/modprobe isn't a shell
> | script wrapper around the actual binary, or you *will* get loop prevention
> | kick in)
> | 	* none of the existing binfmt-<...> aliases is going to be hit
> | now; IOW, all usecases got broken.  Granted, realistically it just means
> | broken modular aout support, but then it's the only reason to have that
> | request_module() there in the first place.
> 
>   Please have a look at the updated patch below.
> 
> It fixes the issue of excessive calls to request_module. find_module() routine 
> is used before request_module(), to see if the module is already loaded or 
> not. Module alias could dodge this though, I guess.

"Could"?  Can you show a single module that would have name matching
binfmt-[0-9a-f]*?  In other words, are they ever loaded _not_ via an
alias?
