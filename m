Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1LURgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:36:31 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43496 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab1LURg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:36:29 -0500
Message-ID: <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 21 Dec 2011 18:36:24 +0100
In-Reply-To: <4EF2117F.6000803@bootc.net>
References: <4EF200BB.7000209@bootc.net>
	 <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF2117F.6000803@bootc.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 décembre 2011 à 17:03 +0000, Chris Boot a écrit :
> On 21/12/2011 16:29, Eric Dumazet wrote:
> > Le mercredi 21 décembre 2011 à 15:52 +0000, Chris Boot a écrit :
> >> Hi folks,
> >>
> >> I'm working on getting a 2-node VM cluster up and running, with DRBD and
> >> Corosync/Pacemaker, running KVM VMs.
> >>
> >> I can trigger a kernel panic in either _host_ system when running an
> >> rsync on a _guest_ VM. The rsync is simply SSH over IPv6 from a remote
> >> mail store (containing maildirs) to a local filesystem. I'm basically
> >> working on migrating a physical IMAP server to one inside a VM.
> >>
> >> After a few seconds of fairly heavy IPv6 traffic, I get the panic below.
> >> You'll notice the panic refers to vhost_net, but I tried without that
> >> and the kernel panics at exactly the same call point.
> >>
> >> Panic:
> >>
> >> [snip]
> >>
> >> Any insight will be gratefully received.
> >>
> >> Thanks,
> >> Chris
> >>
> > Is it a debian kernel ?
> >
> > You need : https://lkml.org/lkml/2011/10/11/291
> 
> Eric,
> 
> Aha, that sounds like exactly the culprit, thanks. However I can't find 
> any reference to it in the 3.1 to 3.1.5 changelogs. Is it fixed in any 
> of those kernels or would I have to attempt to forward-port the fix myself?

Good point, thats a different problem then, since 3.1 is not supposed to
have this bug.

It seems rt->rt6i_peer points to invalid memory in your crash.

(RBX=00000000000001f4)

8b 83 a4 00 00 00       mov    0xa4(%rbx),%eax    p->refcnt
1f4+a4 -> CR2=0000000000000298



