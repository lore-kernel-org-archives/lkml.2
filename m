Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1EJPP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:15:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:49008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab1EJPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:15:28 -0400
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either
 host or guest mode
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <20110510145902.GA30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
	 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
	 <1305038746.2914.94.camel@laptop>  <20110510145902.GA30996@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 17:18:29 +0200
Message-ID: <1305040709.2914.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 16:59 +0200, Roedel, Joerg wrote:
> On Tue, May 10, 2011 at 10:45:46AM -0400, Peter Zijlstra wrote:
> > On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > > +       /* Can't exclude counting in guest and in host mode */
> > > +       if (attr.exclude_host && attr.exclude_guest)
> > > +               return -EINVAL;
> > 
> > Why not?
> 
> By definition the counter won't count at all. The hardware just ignores
> the bits if they are both set. My rationale here was that it does not
> makes sense to setup a counter and exclude guest and host mode.

I would expect it to 'work' but simply return 0. If that isn't what the
AMD hardware does you need to fix that in the AMD driver.

