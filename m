Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0JaBjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 21:39:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3869 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab0JaBjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 21:39:01 -0400
Subject: Re: [PATCH 02/39] arch/alpha: Update WARN uses
From: Joe Perches <joe@perches.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Matt Turner <mattst88@gmail.com>, Jiri Kosina <trivial@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4CCCC224.50007@orcon.net.nz>
References: <cover.1288471897.git.joe@perches.com>
	 <517a3d5c620dd4843a35a05c9a1c123b4b936cd9.1288471898.git.joe@perches.com>
	 <AANLkTi=Po5RaY-mL62trrVm+kuK=0JV7z2oQcDJek4kE@mail.gmail.com>
	 <1288474087.366.145.camel@Joe-Laptop>  <4CCCC224.50007@orcon.net.nz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 18:38:59 -0700
Message-ID: <1288489139.366.169.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-31 at 14:11 +1300, Michael Cree wrote:
> On 31/10/10 10:28, Joe Perches wrote:
> > On Sat, 2010-10-30 at 17:17 -0400, Matt Turner wrote:
> >> On Sat, Oct 30, 2010 at 5:08 PM, Joe Perches<joe@perches.com>  wrote:
> >>> Coalesce long formats.
> >>> Align arguments.
> >> What's accomplished here? It looks like you joined two strings (which
> >> were separated as to not overflow the 80-char limit) and spaced a
> >> couple lines over.
> > This one is just a whitespace cleanup.
> > Ignore it or nack it if you want.
> I prefer the original indenting as it clearly stands the `1' on its own 
> thus emphasising that the warning will be printed everytime the WARN() 
> statement is executed.  I surmise that the original programmer thought 
> it important to emphasise this as it might not be considered the 
> "normal" usage of WARN().

Actually, WARN(1, foo) is by far the most common use of WARN.
More than half of all uses.

$ grep -rP --include=*.[ch] -oh "\bWARN\s*\(" * | wc -l
286
$ grep -rP --include=*.[ch] -oh "\bWARN\s*\(\w+" * | \
	sort | uniq -c | sort -rn | head -5
    173 WARN(1
      8 WARN(IS_ERR
      4 WARN(ret
      4 WARN(priv
      4 WARN(local

> The moral here is that when a _competent_ programmer breaks the "style 
> guide" they are most likely doing so for a very good reason.  Thus, 
> those who would submit whitespace fix patches should take time to ask 
> themselves why the original programmer has laid out the code in such a 
> fashion and learn from it, before submitting so-called "fixes".

Code is decidedly not music.

This stuff is mostly craft not art and consistency in
craft has value.

You might also note I didn't call it a fix, I called it
a whitespace cleanup.

And again, I don't much care if it's applied to
arch/alpha or not.  I haven't had an alpha since I gave
away my AlphaStation a decade ago.

