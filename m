Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471Ab2BNNLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 08:11:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60280 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760196Ab2BNNLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 08:11:17 -0500
Date: Tue, 14 Feb 2012 11:10:46 -0200
From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20120214131046.GA28614@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
 <4F39CBE0.6050806@gmail.com>
 <4F39D00D.2060206@gmail.com>
 <4F39ECDB.5090609@lge.com>
 <4F39EFBB.2010301@gmail.com>
 <20120214105018.GV22598@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214105018.GV22598@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 14, 2012 at 11:50:18AM +0100, Joerg Roedel escreveu:
> On Mon, Feb 13, 2012 at 10:23:07PM -0700, David Ahern wrote:
> > On 2/13/12 10:10 PM, Namhyung Kim wrote:
> > >It happened because I used old kernel version that isn't aware of the
> > >exclude_guest bit. So the check on attr->__reserved_1 in
> > >core.c::perf_copy_attr() failed and then ended up seeing EINVAL at
> > >perf_evsel__open().

> > comes back to 1aed2671738785e8f5aea663a6fda91aa7ef59b5 again. See

> > https://lkml.org/lkml/2012/2/8/234

> Grr. I totally forgot that issue. Is there some way to detect the perf
> kernel-features? Otherwise the only fix seems to be to drop the patch
> changing the default. The crashes should be fixed by the other patch
> already.

Well, we need to detect it like we do with sample_id_all. In this case
we would try with exclude_guest, if it fails with EINVAL, we realise it
is not available, clean that bit and try again.

- Arnaldo
