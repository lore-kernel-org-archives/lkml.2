Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1DOUv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:51:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab1DOUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PEdwd1C7/gIwxuv31kNZc/yR9hyTUMAWkfoxAqflQ59AhzWMhT/ciuG5HJXSj5eNeH
         KLXT8DMhXY0eOPt8QYSIoAeqCch4xkMKB7rVfqChj4Wq6xTe7ic3Sk3QZ7ajSFTYXq9d
         4tBBpbiFw+eaDj5IKy13cqU2wnQ5wUNUFVVAg=
Date: Fri, 15 Apr 2011 23:51:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kstrtox: reuse functions from ctype.h
Message-ID: <20110415205148.GA6132@p183>
References: <b266439c1f03640c677f911cb82f4d0e131d2e7d.1302785632.git.mina86@mina86.com>
 <BANLkTikk3Zof1Go8xLBeq2qyxGo6AFuv1g@mail.gmail.com>
 <op.vtxmkrzr3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vtxmkrzr3l0zgt@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 04:30:17PM +0200, Michal Nazarewicz wrote:
> On Thu, 14 Apr 2011 16:06:34 +0200, Alexey Dobriyan <adobriyan@gmail.com>  
> wrote:

> >> @@ -47,8 +42,8 @@ static int _kstrtoull(const char *s, unsigned int  
> >> base, unsigned long long *res)
> >>
> >>                if ('0' <= *s && *s <= '9')
> >>                        val = *s - '0';
> >> -               else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
> >> -                       val = _tolower(*s) - 'a' + 10;
> >> +               else if (isxdigit(*s))
> >
> > [0-9] are isxdigit() as well, so the code sort of logically duplicate.
> 
> Yes, so? ;)
> 
> I think isxdigit(*s) looks nicer than “'a' <= _tolower(*s) &&
> _tolower(*s) <= 'f'”.

If you write isxdigit(*s) you have to write some other expression for
"val = " to be nicer.

The point it's doesn't matter, compiler will optimize all those _tolower().
