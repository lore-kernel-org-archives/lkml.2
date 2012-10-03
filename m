Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2JCSCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:02:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53795 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2JCSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:02:10 -0400
Date: Wed, 3 Oct 2012 11:02:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Joe Perches <joe@perches.com>,
        Kautuk Consul <consul.kautuk@gmail.com>, linux-mm@kvack.org,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] mm: use %pK for /proc/vmallocinfo
In-Reply-To: <CAGXu5jL4Dd3jCusr+Du4q7tOhcsKaSQbW6u_ZN8ZSBry2AQARg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210031051150.29765@chino.kir.corp.google.com>
References: <20121002234934.GA9194@www.outflux.net> <alpine.DEB.2.00.1210022209070.9523@chino.kir.corp.google.com> <CAGXu5j+ZU_wrqeEYE7GCE6ArFo8z4AO=OW7mOSn0-fp1E9B6+Q@mail.gmail.com> <alpine.DEB.2.00.1210022236370.10573@chino.kir.corp.google.com>
 <CAGXu5jL4Dd3jCusr+Du4q7tOhcsKaSQbW6u_ZN8ZSBry2AQARg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Kees Cook wrote:

> > So root does echo 0 > /proc/sys/kernel/kptr_restrict first.  Again: what
> > are you trying to protect?
> 
> Only CAP_SYS_ADMIN can change the setting. This is, for example, for
> containers, or other situations where a uid 0 process lacking
> CAP_SYS_ADMIN cannot see virtual addresses. It's a very paranoid case,
> yes, but it's part of how this feature was designed. Think of it as
> supporting the recent uid 0 vs ring 0 boundary. :)
> 

The intention of /proc/vmallocinfo being S_IRUSR is obviously to only 
allow root to read this information to begin with, so if root lacks 
CAP_SYS_ADMIN then it seems the best fix would be to return an empty file 
on read()?  Or give permission to everybody to read it but only return a 
positive count when they have CAP_SYS_ADMIN?

There's no need to make this so convoluted that you need to have the right 
combination of uid, kptr_restrict, CAP_SYS_ADMIN, and CAP_SYSLOG to get 
anything valuable out of this file, though.
