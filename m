Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1GMVBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:01:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:40891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1GMVBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:01:35 -0400
Subject: Re: [RFT][PATCH] sched, cgroup: Optimize load_balance_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <CAPM31R+cS+eRaFHa2ygxF3ADYyo5Tf9R+snky3U8b5_am6Wtjg@mail.gmail.com>
References: <1310557009.2586.28.camel@twins>
	 <CAPM31R+cS+eRaFHa2ygxF3ADYyo5Tf9R+snky3U8b5_am6Wtjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 23:01:03 +0200
Message-ID: <1310590863.2586.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 10:13 -0700, Paul Turner wrote:
> > +static void update_h_load(long cpu)
> > +{
> > +       walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
> > +}
> 
> With a list_for_each_entry_reverse_rcu() this could also only operate
> on the local hierarchy and avoid the tg tree walk. 

Ah, sadly that primitive cannot exist, rcu list primitives only keeps
the fwd link.

Although I guess we could 'fix' that.
