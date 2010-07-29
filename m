Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0G2GGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 02:06:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49220 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab0G2GGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 02:06:18 -0400
Date: Wed, 28 Jul 2010 23:00:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Message-ID: <20100729060004.GD2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <18537.1280318862@redhat.com>
 <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com>
 <20100727155023.GF1967@jolsa.brq.redhat.com>
 <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com>
 <24865.1280249187@redhat.com>
 <32758.1280321226@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32758.1280321226@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 01:47:06PM +0100, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > Yeah.  I think there are three alternatives:
> 
> There's a fourth alternative too:
> 
>  (4) I could try and make it so that if the RCU cleanup routine sees it with a
>      non-zero usage count, then it just ignores it.  This, however, would
>      require call_rcu() to be able to cope with requeueing.

It is perfectly legal for an RCU callback to invoke call_rcu().  However,
this should be used -only- to wait for RCU readers.  If there are no
RCU readers, the callback might be re-invoked in very short order,
expecially on UP systems.

Or am I misunderstanding what you mean by "require call_rcu() to be
able to cope iwth requeueing"?

							Thanx, Paul
