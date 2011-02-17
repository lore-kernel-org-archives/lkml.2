Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1BQQDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:03:20 -0500
Received: from blu0-omc1-s35.blu0.hotmail.com ([65.55.116.46]:30104 "EHLO
	blu0-omc1-s35.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756559Ab1BQQDS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:03:18 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP54855482D5C5D51C19328196D50@phx.gbl>
Date: Thu, 17 Feb 2011 11:03:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Will Newton <will.newton@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Simoneau <simoneau@ele.uri.edu>,
        David Miller <davem@davemloft.net>, matt@console-pimps.org,
        peterz@infradead.org, jbaron@redhat.com, mingo@elte.hu,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com> <20110215211123.GA3094@ele.uri.edu> <20110215.132702.39199169.davem@davemloft.net> <20110215215604.GA3177@ele.uri.edu> <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com> <1297858734.23343.138.camel@gandalf.stny.rr.com> <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com> <BLU0-SMTP80F56386E7E060A3B2020B96D20@phx.gbl> <4D5C8019.70301@hitachi.com> <4D5C93B6.5020900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4D5C93B6.5020900@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:59:59 up 316 days,  1:49,  6 users,  load average: 1.56, 1.58,
	1.57
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Feb 2011 16:03:17.0046 (UTC) FILETIME=[30585560:01CBCEBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 02/16/2011 05:55 PM, Masami Hiramatsu wrote:
> > 
> > Hmm, I think that is miss-coding ll/sc.
> > If I understand correctly, usually cache invalidation should be done
> > right before storing value, as MSI protocol does.
> > (or, sc should atomically invalidate the cache line)
> > 
> 
> I suspect in this case one should flush the cache line before ll (a
> cache flush will typically invalidate the ll/sc link.)

hrm, but if you have:

  invalidate
  -> interrupt
     read (fetch the invalidated cacheline)
  ll
  sc

you basically end up in a situation similar to not having any
invalidate, no ? AFAIU, disabling interrupts around the whole
ll-sc-invalidate (or invalidate-ll-sc) seems required for this specific
architecture, so the invalidation is made "atomic" with the ll-sc pair
from the point of view of one hardware thread.

Mathieu

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
