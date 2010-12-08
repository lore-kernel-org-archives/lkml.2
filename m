Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0LHQY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:24:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49773
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab0LHQYz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:24:55 -0500
Date: Wed, 08 Dec 2010 08:25:22 -0800 (PST)
Message-Id: <20101208.082522.226789733.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: gregkh@suse.de, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, holt@sgi.com, w@1wt.eu,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, vladislav.yasevich@hp.com,
        sri@us.ibm.com
Subject: Re: [34/44] Limit sysctl_tcp_mem and sysctl_udp_mem initializers
 to prevent integer overflows.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1291787445.5324.64.camel@edumazet-laptop>
References: <AANLkTimTw3O-OM-5Cgv0ELNj8SmMjaaeMHMd2NNezxi7@mail.gmail.com>
	<20101208041656.GA2291@suse.de>
	<1291787445.5324.64.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 08 Dec 2010 06:50:45 +0100

> Le mardi 07 décembre 2010 à 20:16 -0800, Greg KH a écrit :
>> On Tue, Dec 07, 2010 at 05:22:34PM -0800, Linus Torvalds wrote:
>> > On Tue, Dec 7, 2010 at 4:04 PM, Greg KH <gregkh@suse.de> wrote:
>> > >
>> > > From: Robin Holt <holt@sgi.com>
>> > >
>> > > [ Problem was fixed differently upstream. -DaveM ]
>> > 
>> > Gaah. I'd really like to see more of a description for things like
>> > this. A commit ID for the alternate fix, or at least a few words about
>> > the different fix or reason why upstream doesn't need the stable
>> > commit.
>> 
>> I'll let David confirm this, he's the one who sent it to me :)
> 
> upstream uses commit 8d987e5c7510 (net: avoid limits overflow)
> 
> This commit is a bit more untrusive for stable kernels :
> 
> It depends on :
> a9febbb4bd13 (sysctl: min/max bounds are optional)
> 27b3d80a7b6a (sysctl: fix min/max handling in __do_proc_doulongvec_minmax())

Yep, this is the case.  Greg, you can add a reference to:

a9febbb4bd13
27b3d80a7b6a
8d987e5c7510

in my "[ ... ]" in the commit message to clear this up.
