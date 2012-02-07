Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2BGPWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:22:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2BGPWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:22:45 -0500
Date: Tue, 7 Feb 2012 13:21:44 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: Re: [PATCH v5 11/18] perf: add code to support
	PERF_SAMPLE_BRANCH_STACK
Message-ID: <20120207152144.GN6367@infradead.org>
References: <1328187288-24395-1-git-send-email-eranian@google.com> <1328187288-24395-12-git-send-email-eranian@google.com> <20120206180657.GC6367@infradead.org> <CABPqkBSJj=TvD8W7YApLvawkKrmpdB0hvF8N6jd0fi8TvPEdVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBSJj=TvD8W7YApLvawkKrmpdB0hvF8N6jd0fi8TvPEdVQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 07, 2012 at 03:11:56PM +0100, Stephane Eranian escreveu:
> On Mon, Feb 6, 2012 at 7:06 PM, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> >> +++ b/tools/perf/util/annotate.c
> >> @@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,

> >>       pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));

> >> -     if (addr >= sym->end)
> >> +     if (addr >= sym->end || addr < sym->start)

> > This is not related to this, would be better to come in a separate patch
> > with a proper explanation.

> You mean in this patchset or separately?

Either way it would be standalone, I'd pick it, but please write a
commit message explaining why it is needed.

Multiple people submitted this already but without a good commit message
which I think may be papering over a bug.

- Arnaldo
