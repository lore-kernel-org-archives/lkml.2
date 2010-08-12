Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab0HLObl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:31:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49914 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab0HLObj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YHcwKK7uJBIC9wHFy5DnWUqk+kzJ0FajmtNqOJgwSX3ZG8LMeQMCpju1VFKQ1WA+jX
         g+tR89Cdp0bKAzfHb7BCXlJ0fi0wSwMTdY88BJPDTpAiEjj04ezM7o6ieNYh6UnbkZvl
         tNm+vlpoFpDspakOoTNjiXAPybrfDfqCZNMyE=
Date: Thu, 12 Aug 2010 18:31:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100812143133.GA5719@lenovo>
References: <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100809200245.GF6056@lenovo> <20100810074200.GE26154@erda.amd.com> <20100810161627.GB6893@lenovo> <20100810164124.GK26154@erda.amd.com> <20100810172451.GD6893@lenovo> <20100810190541.GN26154@erda.amd.com> <20100810192428.GE6893@lenovo> <20100812132419.GX26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812132419.GX26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 03:24:19PM +0200, Robert Richter wrote:
> On 10.08.10 15:24:28, Cyrill Gorcunov wrote:
> > On Tue, Aug 10, 2010 at 09:05:41PM +0200, Robert Richter wrote:
> > > On 10.08.10 13:24:51, Cyrill Gorcunov wrote:
> > > 
> > > > It gets masked on NMI arrival, at least for some models (Core Duo, P4,
> > > > P6 M and I suspect more theh that, that was the reason oprofile has
> > > > it, also there is a note in SDM V3a page 643).
> > > 
> > > Yes, that's right, I never noticed that. Maybe it is better to
> > > implement the apic write it in model specific code then.
> > > 
> > 
> > Perhaps we can make it simplier I think, ie like it was before -- we just
> > move it under your new DIE_NMIUNKNOWN, in separate patch of course. Though
> > I'm fine with either way.
> 
> I do not understand why you want to put this in the 'unknown'
> path. Isn't it necessary to unmask the vector with every call of the
> nmi handler?
> 
> -Robert
> 

Heh, it's simple - I'm screwed. Robert you're right, of course it should NOT
be under every 'unknown' nmi. I thought about small optimization here, but
I think all this should be done only _after_ your patch is merged.

Sorry for confuse ;)
 
	-- Cyrill
