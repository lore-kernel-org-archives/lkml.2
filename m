Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0CVLs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:48:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab0CVLs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:48:57 -0400
Date: Mon, 22 Mar 2010 12:48:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322114824.GF3483@elte.hu>
References: <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321200849.GA51323@dspnet.fr.eu.org>
 <4BA67D75.8060809@redhat.com>
 <4BA67F12.6030501@nagafix.co.uk>
 <4BA68063.2050800@redhat.com>
 <4BA68234.1060804@nagafix.co.uk>
 <4BA68997.60406@redhat.com>
 <20100321212009.GE30194@elte.hu>
 <4BA70F9A.8030304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA70F9A.8030304@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > My 10+ years experience with kernel instrumentation solutions is that 
> > kernel-driven, self-sufficient, robust, trustable, well-enumerated sources 
> > of information work far better in practice.
> 
> What about line number information?  And the source?  Into the kernel with 
> them as well?

Sigh. Please read the _very first_ suggestion i made, which solves all that. I 
rarely go into discussions without suggesting technical solutions - i'm not 
interested in flaming, i'm interested in real solutions.

Here it is, repeated for the Nth time:

Allow a guest to (optionally) integrate its VFS namespace with the host side 
as well. An example scheme would be:

   /guests/Fedora-G1/
   /guests/Fedora-G1/proc/
   /guests/Fedora-G1/usr/
   /guests/Fedora-G1/.../
   /guests/OpenSuse-G2/
   /guests/OpenSuse-G2/proc/
   /guests/OpenSuse-G2/usr/
   /guests/OpenSuse-G2/.../

  ( This feature would be configurable and would be default-off, to maintain 
    the current status quo. )

Line number information and the source (dwarf info) and ELF symbols are all 
provided and accessible via such an interface - no need to run any 'symbol 
demon' on the guest side.

And, obviously, having the guest VFS namespace (optionally) available on the 
host side also has far more uses than perf's symbol needs.

I was surprised no-one ever came up with such a suggestion - it is so obvious 
to allow the integration of the VFS namespaces. But given your explicit 
declaration of your KVM desktop usability indifference i'm kind of not 
surprised about that anymore.

Thanks,

	Ingo
