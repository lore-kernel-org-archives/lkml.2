Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0INMVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:21:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52459 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0INMVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:21:39 -0400
Date: Tue, 14 Sep 2010 14:21:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100914122131.GF12425@elte.hu>
References: <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
 <20100913141140.GB27371@redhat.com>
 <20100913172438.37443bf7@basil.nowhere.org>
 <20100913154750.GA26290@redhat.com>
 <20100913185721.59ad9b4d@basil.nowhere.org>
 <20100913175346.GC26290@redhat.com>
 <20100913200707.3b31429e@basil.nowhere.org>
 <20100913182354.GE26290@redhat.com>
 <20100913203654.26724055@basil.nowhere.org>
 <20100913193655.GF26290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913193655.GF26290@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0487]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> > > > At least on PCI-E it may be enough to simply dump all recent AER 
> > > > data.
> > > 
> > > This assumes AER is supported on the bridge?  Which for newer 
> > > chips is probably true, but I wasn't sure about older ones.
> > 
> > Today's servers should usually have AER at least.
> > 
> > For old systems you only can get the few bits in PCI space.
> > 
> > > How would I dump AER data from within the kernel?
> > 
> > Would need a buffer that is dumped for past events and reading the 
> > registers for not yet reported. Right now some infrastructure is 
> > needed.
> 
> Oh ok.

The proper approach would be not to add hacks to the NMI code but to 
implement southbridge drivers - which would also have NMI callbacks. 
These are unchartered waters, but variance in that space is reducing 
systematically so it would be worth a shot.

Thanks,

	Ingo
