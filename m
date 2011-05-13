Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1EMSaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:30:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab1EMSaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:30:15 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=wom5GMh1gUkA:10 a=2uYajzE4MAAA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=Z4Rwk6OoAAAA:8 a=VV-r4apBFXeysI0C4VIA:9 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Fri, 13 May 2011 13:30:12 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: acl_permission_check: disgusting performance
Message-ID: <20110513183012.GA31958@mail.hallyn.com>
References: <BANLkTi=nc3WGaASQm1Pc9byshLOmLf2bXQ@mail.gmail.com>
 <20110513025013.GA13209@mail.hallyn.com>
 <20110513040214.GA25270@mail.hallyn.com>
 <BANLkTim3cy8Jf3URYTW+cbr3nrdWVbsmGw@mail.gmail.com>
 <20110513131904.GA2519@mail.hallyn.com>
 <BANLkTi=yyoMXNqGtVX9KxHjVaDVGW9uzdA@mail.gmail.com>
 <BANLkTin-9SmqB=U7gmOFY2qkCLNd_Yn-sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin-9SmqB=U7gmOFY2qkCLNd_Yn-sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> On Fri, May 13, 2011 at 9:16 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Looks ok to me. And generates good code for acl_permission_check
> > without CONFIG_USER_NS.
> >
> > I'll see how much that function drops on the kernel profiles..
> 
> Yup, looking good.
> 
> For my "kernel make with no changes" workload, it dropped from
> 
>     1.28%           make  [kernel.kallsyms]             [k] acl_permission_check
> 
> to
> 
>      0.88%           make  [kernel.kallsyms]             [k]
> acl_permission_check
> 
> which is pretty much exactly the expected 30% drop from no longer
> having that expensive load of user_ns.
> 
> Of course, that 30% improvement is just a 0.4% performance improvement
> in the big picture, but hey, almost half a percentage point on a real
> load from just one single function in the kernel is definitely worth
> doing.

That's great, thanks for the help.

> Do you want to carry this for 2.6.40, or should I just apply it?

It makes no user-visible difference so I'd say just apply it.

thanks,
-serge
