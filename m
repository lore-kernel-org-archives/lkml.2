Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0HPTNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:13:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab0HPTN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:13:29 -0400
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100816190659.GI5805@lenovo>
References: <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com> <20100811220058.GT26154@erda.amd.com>
	 <1281970116.1926.1495.camel@laptop> <20100816162706.GH5805@lenovo>
	 <20100816171610.GN26154@erda.amd.com>  <20100816190659.GI5805@lenovo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 21:13:16 +0200
Message-ID: <1281985996.1926.1848.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 23:06 +0400, Cyrill Gorcunov wrote:
> I never heard of backward running tsc, though tsc is a strange beast.
> 
Its not supposed to happen, but then there's BIOS failure-add that frobs
the TSC from SMIs and fun TSC artifacts around CPU frequency changes and
people resetting TSC in S-states etc..

In short, never trust the TSC to be even remotely sane.
