Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1BYRsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:48:02 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48719 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1BYRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x8iy5QdYTIrbHxRY+vXREJYXkVpQDBHv3iZJ0kvtN1J/8qv/gOCFurEhBh9fe0v6KW
         /GaHwAHUebgwZCDNTvDx4tKb8rYxDFlOZa/G9lLhz1eSDFL+7lY7KYJW9lmrvc5PcU2p
         psJPD31YICk/yiYZ9udORZdmLurkvI+KKsklM=
Date: Fri, 25 Feb 2011 20:47:51 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Valdis.Kletnieks@vt.edu
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel
 modules
Message-ID: <20110225174751.GA722@albatros>
References: <20110224151238.GA16916@albatros>
 <1298565265.2613.16.camel@bwh-desktop>
 <20110225123023.GA8776@albatros>
 <20110225151414.GA5211@albatros>
 <135187.1298654740@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <135187.1298654740@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 12:25 -0500, Valdis.Kletnieks@vt.edu wrote:
> And you stop an attacker from simply recompiling the module with a suitable
> MODULE_ALIAS line added, how, exactly?  This patch may make sense down the
> road, but not while it's still trivial for a malicious root user to drop stuff
> into /lib/modules.

The threat is not a malicious root, but non-root with CAP_NET_ADMIN.
It's hardly possible to load arbitrary module into the kernel having
CAP_NET_ADMIN without other capabilities.

> And if you're going the route "but SELinux/SMACK/Tomoyo will prevent a malicious
> root user from doing that", then the obvious reply is "this should be part of those
> subsystems rather than something done one-off like this (especially as it has a chance
> of breaking legitimate setups that use the current scheme).

No, I don't want to add anything about LSMs at all.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
