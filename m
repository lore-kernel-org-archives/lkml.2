Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1LENXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:23:49 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:6056
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932202Ab1LENXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:23:47 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz9371K1432N98dK4015Lzz1202hzz8275bhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQFVH-02-A5E-02
X-M-MSG: 
Date: Mon, 5 Dec 2011 14:23:40 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "acme@redhat.com" <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
Message-ID: <20111205132340.GH15738@erda.amd.com>
References: <20110930134040.GA5575@quad>
 <20111129182231.GZ15738@erda.amd.com>
 <CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
 <20111130150829.GA15738@erda.amd.com>
 <20111130164946.GA27163@infradead.org>
 <20111201150151.GA15110@somewhere.redhat.com>
 <20111201151520.GB15738@erda.amd.com>
 <CABPqkBQwQ1gzQEfAehiLRXrO196vovNeRjS9taiM7dfk7U9egQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBQwQ1gzQEfAehiLRXrO196vovNeRjS9taiM7dfk7U9egQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.11 09:53:10, Stephane Eranian wrote:
> On Thu, Dec 1, 2011 at 7:15 AM, Robert Richter <robert.richter@amd.com> wrote:
> > I am asking this because I want to change code in a way that treats
> > all features the same, that is just to disable the feature bit on
> > failure and then continue anyway.
> >
> You need to make sure that disabling the bit is enough to still get a consistent
> file, i.e., want to undo the effect of writing the feature to the
> file. In the case
> of the meta-data features I added that was easy simply lseek() back to
> the position
> before the call. Would that be the case with TRACE_INFO?

It should be. All features can be parsed independently. Offset and
size of a feature's data block is stored in struct perf_file_section
right after the data block of perf.data (see perf_session__write_
header()). Thus, if a feature does not exist then other features can
be processed anyway.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

