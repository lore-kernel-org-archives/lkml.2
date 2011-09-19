Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1ISSor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:44:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51114 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab1ISSoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:44:46 -0400
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Mon, 19 Sep 2011 20:44:28 +0200
In-Reply-To: <4E778C0E.5060000@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	    <1316030695-19826-2-git-send-email-glommer@parallels.com>
	   <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>
	  <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com>
	 <1316457343.6091.11.camel@twins> <4E778C0E.5060000@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316457868.6091.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 15:38 -0300, Glauber Costa wrote:
> On 09/19/2011 03:35 PM, Peter Zijlstra wrote:
> > On Mon, 2011-09-19 at 13:30 -0300, Glauber Costa wrote:
> >> For cpuusage, I am not sure this optimization is a valid one
> >
> > I was talking about cpuusage, cpuacct_charge() is called for every
> > ctxsw/tick.
> 
> I am not touching it right now.

See hunk #4 of this particular patch:

@@ -9302,7 +9308,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)

That's cpuusage muck ;-)

> > But even for cpuacct tick stuff, wouldn't you need to sum all your child
> > cgroups to update the current cgroup? and that up the whole tree?
> 
> Of course I would. But as I said, it does not need to be done every 
> tick, in case it poses such a cacheline mayhem as you fear.
> 
> Since we'll only really need those values when someone reads it - which 
> is a far less frequent operation than the tick resolution - and when a 
> cgroup is destroyed - even less frequent operation - it should work well.

Quite possible, yes. Although if you create a cgroup with 100 subgroups
and poll very frequently.. it all depends on the avg use case etc.. and
since I don't use any of this stuff someone needs to tell me about how
the trade-offs work out in practice.

So explicit changelogs with numbers and agreements from multiple users
go a long way to make me feel good ;-)
