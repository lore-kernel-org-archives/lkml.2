Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab0FJQXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:23:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0FJQXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:23:07 -0400
Date: Thu, 10 Jun 2010 18:22:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 02/13] jump label v9: base patch
Message-ID: <20100610162247.GC19599@elte.hu>
References: <cover.1276116186.git.jbaron@redhat.com>
 <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
 <20100609223548.GB12752@nowhere>
 <20100610154451.GC3923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610154451.GC3923@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> > > +			entry = add_jump_label_entry((char *)iter_begin->name,
> > > +							count, iter_begin);
> > > +			if (IS_ERR(entry))
> > > +				return PTR_ERR(entry);
> > > +			continue;
> > > +		}
> > > +		WARN(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
> > 
> > 
> > 
> > It seems you are going to endless loop in this fail case.
> > 
> 
> agreed. I need to stick that 'WARN' into the else clause of "if
> (!entry)" and return an error.

and make that WARN_ONCE() as well. If it ever triggers it should show up once 
and not compound the bug with spamming the console and the logs.

Thanks,

	Ingo
