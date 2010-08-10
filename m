Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab0HJTYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:24:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61310 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab0HJTYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SyllzS2qYnHcsW+5pIMLl0sioKYr2H03ZI9cm04QiBLkv2gBQqsO7h989Sv5fY7hbz
         A3fzcAUfiiep+VO3Mq79Usw/ORM/iyylentUYiAVFtz7i8DNnZCaYzGK57Mw7j2MH9rE
         ECqb/YE67PWz3YG4U9aEvClnZlBEuvw90AVMU=
Date: Tue, 10 Aug 2010 23:24:28 +0400
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
Message-ID: <20100810192428.GE6893@lenovo>
References: <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100809200245.GF6056@lenovo> <20100810074200.GE26154@erda.amd.com> <20100810161627.GB6893@lenovo> <20100810164124.GK26154@erda.amd.com> <20100810172451.GD6893@lenovo> <20100810190541.GN26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810190541.GN26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 09:05:41PM +0200, Robert Richter wrote:
> On 10.08.10 13:24:51, Cyrill Gorcunov wrote:
> 
> > It gets masked on NMI arrival, at least for some models (Core Duo, P4,
> > P6 M and I suspect more theh that, that was the reason oprofile has
> > it, also there is a note in SDM V3a page 643).
> 
> Yes, that's right, I never noticed that. Maybe it is better to
> implement the apic write it in model specific code then.
> 

Perhaps we can make it simplier I think, ie like it was before -- we just
move it under your new DIE_NMIUNKNOWN, in separate patch of course. Though
I'm fine with either way.

(actually it's interesting to know wouldn't we leave lvt masked when
 we hit 'second delayed nmi has arrived' situation, I guess we didn't
 hit it before in real yet :-)

> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
	-- Cyrill
