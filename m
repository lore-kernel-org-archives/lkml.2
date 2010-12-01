Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0LARcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:32:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39061 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab0LARcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wfFBZo3gQOwaFmpSxVbjHmOc9CGEk8ZC/pc9954vqijH2RribI7foaGqR5aUn62EGg
         lXURVno71dLtS49SXt4aIQUOOnkeDgDB7ILqrYqz5NNlMnNAYNk9ag0O9O/6jZFokL6Y
         +LgL9K/ZfYZJyXYLE0yAw0vPJAkDeIqh3yyzs=
Subject: Re: [Patch] net: kill an RCU warning in inet_fill_link_af()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Graf <tgraf@infradead.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
In-Reply-To: <20101201171801.GA22009@canuck.infradead.org>
References: <1291202063-6239-1-git-send-email-amwang@redhat.com>
	 <1291219386.2856.924.camel@edumazet-laptop>
	 <20101201171801.GA22009@canuck.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 18:31:57 +0100
Message-ID: <1291224717.2856.1021.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 décembre 2010 à 12:18 -0500, Thomas Graf a écrit :
> On Wed, Dec 01, 2010 at 05:03:06PM +0100, Eric Dumazet wrote:
> > [PATCH net-next-2.6] net: kill an RCU warning in inet_fill_link_af()
> > 
> > commits 9f0f7272 (ipv4: AF_INET link address family) and cf7afbfeb8c
> > (rtnl: make link af-specific updates atomic) used incorrect
> > __in_dev_get_rcu() in RTNL protected contexts, triggering PROVE_RCU
> > warnings.
> > 
> > Switch to __in_dev_get_rtnl(), wich is more appropriate, since we hold
> > RTNL.
> > 
> > Based on a report and initial patch from Amerigo Wang.
> 
> RTNL is not held while dumping, it is only held for get and set, but we
> still hold rcu readlocks while dumping so there should be no asserts
> triggered. Thanks for fixing this.

Are you sure RTNL is not held while dumping ? 

Patrick did the change to hold RTNL while dumping too, 3.5 years ago.
Check commits 6313c1e0992fea, 1c2d670f3660e9103 ([RTNETLINK]: Hold
rtnl_mutex during netlink dump callbacks)

If this was the case (not holding RTNL), we should use
rcu_dereference(), not rtnl_dereference()



