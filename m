Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0HTMuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:50:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38488 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0HTMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:50:00 -0400
Date: Fri, 20 Aug 2010 06:49:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce ptr_diff()
Message-ID: <20100820124958.GJ12892@parisc-linux.org>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com> <87aaoiu6z6.fsf@basil.nowhere.org> <20100820120737.GS31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820120737.GS31363@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 01:07:37PM +0100, Al Viro wrote:
> On Thu, Aug 19, 2010 at 02:23:09PM +0200, Andi Kleen wrote:
> > IMHO it would be better to simply disable the warning in sparse instead
> > of uglying the code just to work around sparse bogosity. It doesnt' seem
> > to make much sense. A subtraction followed by a shift is not expensive.
> 
> "Bogosity" in question is quite real and proposed "fix" actually makes the
> things even worse.  At least gcc bothers to optimize the division in there...
> 
> Basically, sparse warns about pointer subtractions that divide by constants
> that are not powers of two.  Which _does_ have non-trivial price, even with
> optimizations done by gcc.

I'm not sure the price is so high.  I googled around and came across
http://mdfs.net/Docs/Comp/ARM/Cookbook/cook3 (section 3.3).  Dividing by
2^n, (2^n + 2^m) or (2^n - 2^m) can be done using a small series of adds
and subtractions (important on ARM as it had no divide instruction at
the time).  Most structures are going to be of one of these sizes ...
and in particular, struct page is 56 bytes in my config, which is 64 - 8.
Maybe sparse needs to be taught that dividing by 2^n [+-] 2^m is cheap
enough to not warn about.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
