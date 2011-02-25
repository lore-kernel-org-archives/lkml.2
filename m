Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab1BYTCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:02:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62816 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab1BYTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oMF5TR5CNYfugT2TjJ4BI7sdqTPlSWbC94AB0MAmD0y/n81W3S5KsOg5CjO0NQR0T5
         HqO/h6jo1g8Vcyqdw0sJNOny04gZJS38RnSUDR8JDGPgLhoGHrxpX4PAjF/s8NCd5d6x
         TPumV8ql9l98o+9X9twbabp2wNyjqk5oCO4lU=
Date: Fri, 25 Feb 2011 22:02:05 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com,
        Kees Cook <kees.cook@canonical.com>, Eugene Teo <eugene@redhat.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel
 modules
Message-ID: <20110225190205.GA4541@albatros>
References: <1298565265.2613.16.camel@bwh-desktop>
 <20110225123023.GA8776@albatros>
 <20110225151414.GA5211@albatros>
 <20110225.104720.71110261.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225.104720.71110261.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:47 -0800, David Miller wrote:
> From: Vasiliy Kulikov <segoon@openwall.com>
> Date: Fri, 25 Feb 2011 18:14:14 +0300
> 
> > Since a8f80e8ff94ecba629542d9b4b5f5a8ee3eb565c any process with
> > CAP_NET_ADMIN may load any module from /lib/modules/.  This doesn't mean
> > that CAP_NET_ADMIN is a superset of CAP_SYS_MODULE as modules are limited
> > to /lib/modules/**.  However, CAP_NET_ADMIN capability shouldn't allow
> > anybody load any module not related to networking.
> 
> Why go through this naming change, which does break things, instead of
> simply adding a capability mask tag or similar to modules somehow.  You
> could stick it into a special elf section or similar.
>
> Doesn't that make tons more sense than this?

This is not "simply", adding special section for a single workaround
seems like an overkill for me - this touches the core (modules'
internals), which is not related to the initial CAP_* problem at all.

I'd be happy with not breaking anything, but I don't see any acceptable
solution.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
