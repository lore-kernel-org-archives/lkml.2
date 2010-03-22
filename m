Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0CVUWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:22:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0CVUWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:22:04 -0400
Date: Mon, 22 Mar 2010 21:21:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       LKML Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel General <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322202144.GF3306@elte.hu>
References: <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7AF2D.7060306@redhat.com>
 <4BA7C1D7.5070208@codemonkey.ws>
 <20100322193100.GB28709@redhat.com>
 <E548536E-4D62-4B17-BA09-9C12EB1A2717@suse.de>
 <20100322195403.GC3306@elte.hu>
 <2D740A89-F53F-4F72-B44C-B72942E883E9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2D740A89-F53F-4F72-B44C-B72942E883E9@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Graf <agraf@suse.de> wrote:

> > Furthermore, another negative effect is that many times features are 
> > implemented not in their technically best way, but in a way to keep them 
> > local to the project that originates them. This is done to keep deployment 
> > latencies and general contribution overhead down to a minimum. The moment 
> > you have to work with yet another project, the overhead adds up.
> 
> I disagree there. Keeping things local and self-contained has been the UNIX 
> secret. It works really well as long as the boundaries are well defined.

The 'UNIX secret' works for text driven pipelined commands where we are 
essentially programming via narrow ASCII input of mathematical logic.

It doesnt work for a GUI that is a 2D/3D environment of millions of pixels, 
shaped by human visual perception of prettiness, familiarity and efficiency.

> The problem we're facing is that we're simply lacking an active GUI / 
> desktop user development community. We have desktop users, but nobody feels 
> like tackling the issue of doing a great GUI project while talking to 
> qemu-devel about his needs.

Have you made thoughts about why that might be so?

I think it's because of what i outlined above - that you are trying to apply 
the "UNIX secret" to GUIs - and that is a mistake.

A good GUI is almost at the _exact opposite spectrum_ of good command-line 
tool: tightly integrated, with 'layering violations' designed into it all over 
the place:

  look i can paste the text from an editor straight into a firefox form. I
  didnt go through any hiearchy of layers, i just took the shortest path 
  between the apps!

In other words: in a GUI the output controls the design, for command-line 
tools the design controls the output.

It is no wonder Unix always had its problems with creating good GUIs that are 
efficient to humans. A good GUI works like the human brain, and the human 
brain does not mind 'layering violations' when that gets it a more efficient 
result.

> > So developers rather go for the quicker (yet inferior) hack within the 
> > sub-project they have best access to.
> 
> Well - not necessarily hacks. It's more about project boundaries. Nothing is 
> bad about that. You wouldn't want "ls" implemented in the Linux kernel 
> either, right? :-)

I guess you are talking to the wrong person as i actually have implemented ls 
functionality in the kernel, using async IO concepts and extreme threading ;-) 
It was a bit crazy, but was also the fastest FTP server ever running on this 
planet.

	Ingo
