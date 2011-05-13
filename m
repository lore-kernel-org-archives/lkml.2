Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab1EMQa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:30:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759041Ab1EMQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=yyoMXNqGtVX9KxHjVaDVGW9uzdA@mail.gmail.com>
References: <BANLkTi=nc3WGaASQm1Pc9byshLOmLf2bXQ@mail.gmail.com>
 <20110513025013.GA13209@mail.hallyn.com> <20110513040214.GA25270@mail.hallyn.com>
 <BANLkTim3cy8Jf3URYTW+cbr3nrdWVbsmGw@mail.gmail.com> <20110513131904.GA2519@mail.hallyn.com>
 <BANLkTi=yyoMXNqGtVX9KxHjVaDVGW9uzdA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 May 2011 09:29:27 -0700
Message-ID: <BANLkTin-9SmqB=U7gmOFY2qkCLNd_Yn-sw@mail.gmail.com>
Subject: Re: acl_permission_check: disgusting performance
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 9:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Looks ok to me. And generates good code for acl_permission_check
> without CONFIG_USER_NS.
>
> I'll see how much that function drops on the kernel profiles..

Yup, looking good.

For my "kernel make with no changes" workload, it dropped from

    1.28%           make  [kernel.kallsyms]             [k] acl_permission_check

to

     0.88%           make  [kernel.kallsyms]             [k]
acl_permission_check

which is pretty much exactly the expected 30% drop from no longer
having that expensive load of user_ns.

Of course, that 30% improvement is just a 0.4% performance improvement
in the big picture, but hey, almost half a percentage point on a real
load from just one single function in the kernel is definitely worth
doing.

Do you want to carry this for 2.6.40, or should I just apply it?

                                Linus
