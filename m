Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0IMPYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:24:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab0IMPYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:24:49 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, markus.t.metzger@intel.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
In-Reply-To: <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	 <20100913150914.GA6155@nowhere>
	 <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	 <1284391000.2275.338.camel@laptop>
	 <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 17:24:40 +0200
Message-ID: <1284391480.2275.350.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 17:20 +0200, Stephane Eranian wrote:

> That is the case we the sizes you have chosen today. For DS, we
> could round up to one page for now.

Markus chose the BTS size, for PEBS a single page was plenty since we do
single event things (although we could do multiple for attr.precise_ip <
2).

For DS there's:
  kmalloc_node(sizeof(struct ds), GFP_KERNEL | __GFP_ZERO, cpu_node(cpu));


