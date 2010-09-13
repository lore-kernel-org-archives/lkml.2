Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0IMRge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:36:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:50818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab0IMRgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:36:33 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
In-Reply-To: <AANLkTimi8=5LM+sx3OgzNCa8V0jG040qZLu=KdWOH945@mail.gmail.com>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	 <20100913150914.GA6155@nowhere>
	 <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	 <1284391000.2275.338.camel@laptop>
	 <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
	 <1284391480.2275.350.camel@laptop>
	 <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
	 <1284392476.2275.369.camel@laptop>
	 <AANLkTimi8=5LM+sx3OgzNCa8V0jG040qZLu=KdWOH945@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 19:36:01 +0200
Message-ID: <1284399361.2275.388.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 19:24 +0200, Stephane Eranian wrote:
> Based on this comment, I assume that the only reason the allocation
> of the sampling buffer in perf_buffer_alloc() is immune to this is because
> you are allocating each page individually (order 0). Right? 

Right, and I software stitch the bits together.
