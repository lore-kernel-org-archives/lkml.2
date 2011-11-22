Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1KVOXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:23:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36392 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1KVOXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:23:31 -0500
Message-ID: <1321971798.14799.12.camel@twins>
Subject: RE: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhu, DengCheng" <dczhu@mips.com>
Cc: "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 15:23:18 +0100
In-Reply-To: <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA871@exchdb03.mips.com>
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>
	 ,<1321959115.5148.22.camel@twins>
	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA82C@exchdb03.mips.com>
	,<1321969559.14799.7.camel@twins>
	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA871@exchdb03.mips.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 14:20 +0000, Zhu, DengCheng wrote:
> > @@ -2463,11 +2461,25 @@ static int event_enable_on_exec(struct p
> >        if (event->state >= PERF_EVENT_STATE_INACTIVE)
> >                return 0;
> >
> > -       __perf_event_mark_enabled(event, ctx);
> > +       event->state = PERF_EVENT_STATE_INACTIVE;
> >
> >        return 1;
> >  }
> 
> By simply setting the event state in here, we bypass time stamp stuff as a result.
> This might lead to inaccuracies... 

Ah, but it calls a __perf_event_mark_enabled() at the tail of
group_enable_on_exec() which should fix that up, right?
