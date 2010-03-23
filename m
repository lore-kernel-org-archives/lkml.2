Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0CWKtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:49:16 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:55699 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab0CWKtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:49:14 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o2NAmNS1006880
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Graf <agraf@suse.de>, "Daniel P. Berrange" <berrange@redhat.com>,
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
In-Reply-To: <20100322202144.GF3306@elte.hu>
References: <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu>
	 <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu>
	 <4BA7AF2D.7060306@redhat.com> <4BA7C1D7.5070208@codemonkey.ws>
	 <20100322193100.GB28709@redhat.com>
	 <E548536E-4D62-4B17-BA09-9C12EB1A2717@suse.de>
	 <20100322195403.GC3306@elte.hu>
	 <2D740A89-F53F-4F72-B44C-B72942E883E9@suse.de>
	 <20100322202144.GF3306@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 11:48:23 +0100
Message-ID: <1269341303.3656.23.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-HP_X86_64_4CPU-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 21:21 +0100, Ingo Molnar wrote:
[...]
> Have you made thoughts about why that might be so?

Yes.

Forword: I assume with "GUI" you mean "a user interface for the
classical desktop user with next to no interest in learning details or
basics".
That doesn't mean the classical desktop user is silly, stupid or
otherwise handicapped - it's just the lack of interest and/or time.

> I think it's because of what i outlined above - that you are trying to apply 
> the "UNIX secret" to GUIs - and that is a mistake.

No, it's the very same mechanism. But you just have to start at the
correct point. In the kernel/device driver world, you start at the
device.
And in the GUI world, you better start at the GUI (and not some kernel
API, library API, GUI tool or toolchains or anywhere else).

> A good GUI is almost at the _exact opposite spectrum_ of good command-line 
> tool: tightly integrated, with 'layering violations' designed into it all over 
> the place:
>
>   look i can paste the text from an editor straight into a firefox form. I
>   didnt go through any hiearchy of layers, i just took the shortest path 
>   between the apps!
> 
> In other words: in a GUI the output controls the design, for command-line 
ACK, because you to make the GUI understandable to the intended users.
If that means "hiding 90% of all possibilities and features", you just
hide them.
Of course, the user of such an UI is quite limited doesn't use much of
the functionality - because s/he can't access it through the GUI - (but
presenting 100% - or even 40% - doesn't help either as s/he won't
understand it anyways).

> tools the design controls the output.
ACK, because the user in this case (which is most of the time a
developer, sys-admin, or similar techie) *wants* an 1:1 picture of the
underlying model because s/he already *knows* the underlying model (and
is willing and able to adapt the own workflow to the underlying models).

> It is no wonder Unix always had its problems with creating good GUIs that are 

ACK. The clichee-Unix-person doesn't come from the "GUI world". So most
of them are "trained" and used to look what's there and improve on it.

> efficient to humans. A good GUI works like the human brain, and the human 
> brain does not mind 'layering violations' when that gets it a more efficient 
> result.

If this is the case, the layering/structure/design of the GUI is (very)
badly defined/chosen (for whatever reason).

[ Most probably because some seasoned software developer designed the
GUI-app *without* designing (and testing!) the GUI (or more to the
point: the look - how does it look like - and feel - how does it behave,
what are the possible workflows, ... - of it) first. ]

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

