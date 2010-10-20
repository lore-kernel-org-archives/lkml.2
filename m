Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0JTQTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:19:52 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48309 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0JTQTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:19:52 -0400
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinteS8FFNZQ6ZadB4WMZUUKYeTYfatggBNdF1xA@mail.gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	 <1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
	 <1286954453.29097.58.camel@twins>
	 <AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com>
	 <20101014112000.GA5336@nowhere>
	 <AANLkTimVPNntcSexdRnkvd+4VdGf2HU+rM7Zhyu=i7CS@mail.gmail.com>
	 <20101015225722.GA5354@nowhere> <1287310023.1998.150.camel@laptop>
	 <AANLkTi=Ja1Yem9Nkdz06_ZxtvxGZUPbGYqusfcf3iN-G@mail.gmail.com>
	 <20101018223539.GB5370@nowhere>
	 <AANLkTinteS8FFNZQ6ZadB4WMZUUKYeTYfatggBNdF1xA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 18:19:39 +0200
Message-ID: <1287591579.3488.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 11:24 +0200, Stephane Eranian wrote:
> 
> The alternative would be to invent yet another generic abstraction
> to sample cache misses. Note that PEBS cache miss sampling
> cannot be attached to an existing generic cache miss event. It
> uses a dedicated event which does not count all cache misses. 

Yeah, the IBS trainwreck comes to mind, I wish the PMU designers
wouldn't create such a mess.

I really dislike using PERF_SAMPLE_RAW for things like this, because it
fully arch dependent.
