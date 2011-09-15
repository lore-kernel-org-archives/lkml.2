Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1IOFkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 01:40:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52269 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1IOFkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 01:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <1315448656.31737.252.camel@debian>
References: <1315188460.31737.5.camel@debian>
	<alpine.DEB.2.00.1109061914440.18646@router.home>
	<1315357399.31737.49.camel@debian>
	<alpine.DEB.2.00.1109062022100.20474@router.home>
	<4E671E5C.7010405@cs.helsinki.fi>
	<6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>
	<alpine.DEB.2.00.1109071003240.9406@router.home>
	<1315442639.31737.224.camel@debian>
	<1315445674.29510.74.camel@sli10-conroe>
	<1315448656.31737.252.camel@debian>
Date: Thu, 15 Sep 2011 08:40:13 +0300
X-Google-Sender-Auth: My6RMGiN_ipLYnKokQ_2vvzmrbg
Message-ID: <CAOJsxLFeZS-6wt+_+Lronc5ds-D05=PYDHna4-8pNu8aBP+pCw@mail.gmail.com>
Subject: Re: [PATCH] slub Discard slab page only when node partials > minimum setting
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 5:24 AM, Alex,Shi <alex.shi@intel.com> wrote:
>> > BTW, some testing results for your PCP SLUB:
>> >
>> > for hackbench process testing:
>> > on WSM-EP, inc ~60%, NHM-EP inc ~25%
>> > on NHM-EX, inc ~200%, core2-EP, inc ~250%.
>> > on Tigerton-EX, inc 1900%, :)
>> >
>> > for hackbench thread testing:
>> > on WSM-EP, no clear inc, NHM-EP no clear inc
>> > on NHM-EX, inc 10%, core2-EP, inc ~20%.
>> > on Tigertion-EX, inc 100%,
>> >
>> > for  netperf loopback testing, no clear performance change.
>> did you add my patch to add page to partial list tail in the test?
>> Without it the per-cpu partial list can have more significant impact to
>> reduce lock contention, so the result isn't precise.
>>
>
> No, the penberg tree did include your patch on slub/partial head.
> Actually PCP won't take that path, so, there is no need for your patch.
> I daft a patch to remove some unused code in __slab_free, that related
> this, and will send it out later.

Which patch is that? Please send me it to penberg@cs.helsinki.fi as
@kernel.org email forward isn't working.
