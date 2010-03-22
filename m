Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0CVPzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:55:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38351 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab0CVPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:55:37 -0400
Date: Mon, 22 Mar 2010 16:55:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322155505.GA18796@elte.hu>
References: <20100321205531.GC30194@elte.hu>
 <4BA692C3.7010408@redhat.com>
 <20100321215455.GB13219@elte.hu>
 <4BA7187E.3050405@redhat.com>
 <20100322111411.GC3483@elte.hu>
 <4BA7629B.7020604@redhat.com>
 <20100322124428.GA12475@elte.hu>
 <4BA76810.4040609@redhat.com>
 <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7821C.7090900@codemonkey.ws>
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


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> [...]
> 
> I've been trying very hard to turn this into a productive thread attempting 
> to capture your feedback and give clear suggestions about how you can solve 
> achieve your desired functionality.

I'm glad that we are at this more productive stage. I'm still trying to 
achieve the very same technological capabilities that i expressed in the first 
few mails when i reviewed the 'perf kvm' patch that was submitted by Yanmin.

The crux of the problem is very simple. To quote my earlier mail:

 |
 | - The inconvenience of having to type:
 |      perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
 |               --guestmodules=/home/ymzhang/guest/modules top
 |
 |
 |   is very obvious even with a single guest. Now multiply that by more guests ...
 |

For example we want 'perf kvm top' to do something useful by default: it 
should find the first guest running and it should report its profile.

The tool shouldnt have to guess about where the guests are, what their 
namespaces is and how to talk to them. We also want easy symbolic access to 
guest, for example:

  perf kvm -g OpenSuse-2 record sleep 1

I.e.:

 - Easy default reference to guest instances, and a way for tools to
   reference them symbolically as well in the multi-guest case. Preferably
   something trustable and kernel-provided - not some indirect information 
   like a PID file created by libvirt-manager or so.

 - Guest-transparent VFS integration into the host, to recover symbols and 
   debug info in binaries, etc.

There were a few responses to that but none really addressed those problems - 
they mostly tried to re-define the problem and suggested that i was wrong to 
want such capabilities and suggested various inferior approaches instead. See 
the thread for the details - i think i covered every technical suggestion that 
was made.

So we are still at an impasse as far as i can see. If i overlooked some 
suggestion that addresses these problems then please let me know ...

Thanks,

	Ingo
