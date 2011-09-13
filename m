Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1IMOqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1IMOp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:45:59 -0400
Date: Tue, 13 Sep 2011 11:40:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
Message-ID: <20110913144051.GA23034@ghostprotocols.net>
References: <20110907191045.GA13475@quad> <4E6E0D0B.3080306@gmail.com> <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com> <4E6E181E.9080506@gmail.com> <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com> <1315838611.26517.51.camel@twins> <CABPqkBSJdCahCugQDyJnoKrB3iFh-yEWNF4Ckm0pRjbcFiKvkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSJdCahCugQDyJnoKrB3iFh-yEWNF4Ckm0pRjbcFiKvkA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 12, 2011 at 04:47:21PM +0200, Stephane Eranian escreveu:
> On Mon, Sep 12, 2011 at 4:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2011-09-12 at 16:40 +0200, Stephane Eranian wrote:
> >> I don't think this should be the test to detect endianess.
> >
> > You should be able to tell the endianness from the PERF_MAGIC string, it
> > stores the string as a u64, so depending on endianness it reads back as
> > either: PERFFILE or ELIFFREP or whatever the bswap64 result is.
> >
> right, something like that...

Yeah, right, reading this thread I could swear it was done like that :-\

Just set needs_swap based on the magic number in perf_file_header__read().

- Arnaldo
