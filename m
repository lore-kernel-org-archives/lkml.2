Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2KTQu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:50:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46191 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2KTQu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:50:28 -0500
Date: Tue, 20 Nov 2012 17:50:19 +0100
From: Robert Richter <rric@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: POWER-event translation questions
Message-ID: <20121120165019.GP2504@rric.localhost>
References: <20121108011035.GA20670@us.ibm.com>
 <CABPqkBQrUVTY9rfeaO+pdaNwZcAgXF45SHnAYJfTvi4HAsPPeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQrUVTY9rfeaO+pdaNwZcAgXF45SHnAYJfTvi4HAsPPeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.12 11:26:26, Stephane Eranian wrote:
> On Thu, Nov 8, 2012 at 2:10 AM, Sukadev Bhattiprolu
> <sukadev@linux.vnet.ibm.com> wrote:

> > 2. Can we allow hyphens in the {name} token  (please see my change to
> >    util/parse-events.l below). With this change, I can run:
> >
> The current code does not support this but Andi fixed that in his HSW patch
> and I use it for the PEBS-LL patch series as well.
>
> >           perf stat -e cpu/cmplu-stall-bru /tmp/nop
> >
> >    without any changes to the user level tool (parse-events.l) I have
> >    tested some common cases, not sure if it will break something :-)

But ...

> > diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> > index c87efc1..1967bb2 100644
> > --- a/tools/perf/util/parse-events.l
> > +++ b/tools/perf/util/parse-events.l
> > @@ -80,7 +80,7 @@ event         [^,{}/]+
> >  num_dec                [0-9]+
> >  num_hex                0x[a-fA-F0-9]+
> >  num_raw_hex    [a-fA-F0-9]+
> > -name           [a-zA-Z_*?][a-zA-Z0-9_*?]*
> > +name           [-a-zA-Z_*?][-a-zA-Z0-9_*?]*
                     ^

... I wouldn't allow hyphens at the beginning of a name.

And, I am wondering if parsing reserved names like 'cpu-cycles' works
too, e.g. cpu/cpu-cycles-foobar/. There are many reserved words in the
lexer with hyphens in it. This might cause unexpected problems.

-Robert
