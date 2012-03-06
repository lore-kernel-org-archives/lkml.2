Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2CFG2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:28:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab2CFG2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:28:03 -0500
Date: Tue, 6 Mar 2012 07:27:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120306062727.GA5100@elte.hu>
References: <20120224094048.GA7952@quad>
 <20120305154753.GA14604@elte.hu>
 <20120305155011.GA32413@elte.hu>
 <20120305155642.GB32413@elte.hu>
 <1330965033.11248.240.camel@twins>
 <20120305203518.GA5656@infradead.org>
 <4F55337B.4080807@fb.com>
 <20120305222614.GB5656@infradead.org>
 <4F554DC7.8010504@fb.com>
 <20120306030635.GC5656@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306030635.GC5656@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> > Something like this seems to do it for me.
> > 
> >         offset = addr - sym->start;
> > +       len = sym->end - sym->start;
> > +       if (offset >= len)
> > +               return 0;
> > +
> 
> That is my fault, I should have added a BUG_ON() spitting out 
> a callchain in this case, as that function shouldn't be called 
> if the address is not within its range :-\

Btw., I'd suggest not doing a BUG_ON() but some less destructive 
warning: both symbol table errors and sample stream hickups are 
common and can lead to essentially arbitrary input data - we 
shouldn't crash on that.

Thanks,

	Ingo
