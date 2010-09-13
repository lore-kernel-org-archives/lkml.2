Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0IMPRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:17:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:36337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0IMPRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:17:14 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, markus.t.metzger@intel.com
In-Reply-To: <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	 <20100913150914.GA6155@nowhere>
	 <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 17:16:40 +0200
Message-ID: <1284391000.2275.338.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 17:13 +0200, Stephane Eranian wrote:
> > For now I think you can not do this. vmalloc'ed memory can't be safely
> > accessed from NMIs in x86 because that might fault. And faults from NMIs
> > are not supported. They cause very bad things: return from fault calls
> > iret which reenables NMI, so NMI can nest but in the meantime there is
> > only one NMI stack, so that gets quickly messed up.
> >
> What kind of faults are you talking about here? TLB faults?

Page faults. vmalloc pte setup is lazy.
