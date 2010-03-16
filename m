Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937884Ab0CPNJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:09:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933034Ab0CPNJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:09:06 -0400
Date: Tue, 16 Mar 2010 14:08:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316130840.GA24808@elte.hu>
References: <20100316095336.GI7961@elte.hu>
 <4B9F59DE.1060008@redhat.com>
 <20100316102052.GC10069@elte.hu>
 <4B9F603B.4080004@redhat.com>
 <20100316105021.GA14344@elte.hu>
 <4B9F671D.5060001@redhat.com>
 <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F7C6A.3070207@redhat.com>
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

> On 03/16/2010 02:29 PM, Ingo Molnar wrote:

> > I mean, i can trust a kernel service and i can trust /proc/kallsyms.
> >
> > Can perf trust a random process claiming to be Qemu? What's the trust 
> > mechanism here?
> 
> Obviously you can't trust anything you get from a guest, no matter how you 
> get it.

I'm not talking about the symbol strings and addresses, and the object 
contents for allocation (or debuginfo). I'm talking about the basic protocol 
of establishing which guest is which.

I.e. we really want to be able users to:

 1) have it all working with a single guest, without having to specify 'which' 
    guest (qemu PID) to work with. That is the dominant usecase both for 
    developers and for a fair portion of testers.

 2) Have some reasonable symbolic identification for guests. For example a 
    usable approach would be to have 'perf kvm list', which would list all 
    currently active guests:

     $ perf kvm list
       [1] Fedora
       [2] OpenSuse
       [3] Windows-XP
       [4] Windows-7

    And from that point on 'perf kvm -g OpenSuse record' would do the obvious 
    thing. Users will be able to just use the 'OpenSuse' symbolic name for 
    that guest, even if the guest got restarted and switched its main PID.

Any such facility needs trusted enumeration and a protocol where i can trust 
that the information i got is authorative. (I.e. 'OpenSuse' truly matches to 
the OpenSuse session - not to some local user starting up a Qemu instance that 
claims to be 'OpenSuse'.)

Is such a scheme possible/available? I suspect all the KVM configuration tools 
(i havent used them in some time - gui and command-line tools alike) use 
similar methods to ease guest management?

	Ingo
