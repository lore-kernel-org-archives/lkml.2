Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0LGJcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:32:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52234 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab0LGJcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T42bkJolDyU6s5dN9YpwGtQUdkY17Zd6RGd7cqSF/f23uXuY0fUKsgg96fgh5c2L7l
         Bs4HLKamRIsmvNhOBSJ0JHHudz5vue2T9+n7Brfl8cMJVxbfHthRDMeJgXQwLjSW0RcZ
         NHvww+6m/aHaP8k/ltzOn66cGxitEClvfbS4E=
Date: Tue, 7 Dec 2010 11:32:29 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jesper Juhl <jj@chaosbits.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/45] kstrtox: converting strings to integers done
 (hopefully) right
Message-ID: <20101207093229.GB29776@core2.telecom.by>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
 <alpine.LNX.2.00.1012060120590.16078@swampdragon.chaosbits.net>
 <AANLkTinbq+NPHBQ=zqVNjUDL+G3fKdC6S9gYB5e4isNR@mail.gmail.com>
 <201012071004.58311.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012071004.58311.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 10:04:58AM +0100, Arnd Bergmann wrote:
> On Monday 06 December 2010 16:16:36 Alexey Dobriyan wrote:
> > > <snip>
> > >> +/* Internal, do not use. */
> > >> +int _kstrtol(const char *s, unsigned int base, long *res)
> > >> +{
> > >> +     long long tmp;
> > >> +     int rv;
> > >> +
> > >> +     rv = kstrtoll(s, base, &tmp);
> > >> +     if (rv < 0)
> > >> +             return rv;
> > >> +     if (tmp != (long long)(long)tmp)
> > >> +             return -EINVAL;
> > >> +     *res = tmp;
> > >> +     return 0;
> > >> +}
> > >> +EXPORT_SYMBOL(_kstrtol);
> > >
> > > Ok, probably I'm just being dense, but the "_" prefix tells me I probably
> > > shouldn't use this function. The comment clearly tells me I shouldn't use
> > > this function.
> > > So, why is this exported? And if it is not/should not be exported, then
> > > why is it not static?
> > > (goes for other functions in this patch as well).
> > 
> > It is used by kstrtol() if "long" and "long long" aren't the same type.
> > I can't ifdef it because gcc doesn't allow "#if sizeof(long long) == ".
> > "Do not use" hints "use kstrtol()".
> 
> Can't you use #ifdef CONFIG_64BIT to see if long is 64 bit wide?

I could, but there are no defines for alignment.
