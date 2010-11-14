Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab0KNDFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 22:05:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38795 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0KNDFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 22:05:49 -0500
Date: Sat, 13 Nov 2010 19:05:34 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, James Morris <jmorris@namei.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with
 CONFIG_EMBEDDED=y and CONFIG_PRINTK=n
Message-ID: <20101114030534.GH13854@outflux.net>
References: <1289669176.16461.12.camel@Joe-Laptop>
 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
 <1289672721.3090.349.camel@Dan>
 <AANLkTi=4AQst9bNXrvwN6sZc2CM9rccYbERYYQkVK99q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=4AQst9bNXrvwN6sZc2CM9rccYbERYYQkVK99q@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 12:22:15PM -0800, Linus Torvalds wrote:
> Hmm. No wonder I missed that. The security interface is totally
> idiotic. If the intention is for /proc/kmsg security checks to be done
> at open time, then dammit, that logic should _not_ be inside some
> random security policy.

I think the real problem is that this interface exists as both a syscall
and a /proc file (sysklogd things use the /proc file). Dropping the
from_file means that security policy cannot revalidate the policy
(sometimes it might want to block the read, i.e. passing the open fd to
another process that is not privileged). But since nothing is actually
using from_file yet, I guess it's not a big deal.

And note that I'm not defending any specific part of it; I'm just trying
to point out what not be possible in the future if we drop from_file
like this.

-Kees

-- 
Kees Cook
Ubuntu Security Team
