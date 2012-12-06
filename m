Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2LFBHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:07:14 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44360 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab2LFBHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:07:12 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-f9-50bfefbd5465
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf hists: Link hist entries before inserting to an output tree
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
	<1354690603-31364-3-git-send-email-namhyung@kernel.org>
	<20121205190646.GB1037@krava.brq.redhat.com>
	<20121205191547.GC1037@krava.brq.redhat.com>
Date: Thu, 06 Dec 2012 10:07:09 +0900
In-Reply-To: <20121205191547.GC1037@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 5 Dec 2012 20:15:47 +0100")
Message-ID: <878v9cdm4i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012 20:15:47 +0100, Jiri Olsa wrote:
> On Wed, Dec 05, 2012 at 08:06:46PM +0100, Jiri Olsa wrote:
>> On Wed, Dec 05, 2012 at 03:56:42PM +0900, Namhyung Kim wrote:
>> > From: Namhyung Kim <namhyung.kim@lge.com>
>> > @@ -481,6 +459,11 @@ static void hists__process(struct hists *old, struct hists *new)
>> >  	else
>> >  		hists__link(new, old);
>> >  
>> > +	hists__output_resort(new);
>> > +
>> > +	if (show_displacement)
>> > +		hists__compute_position(new);
>> > +
>> 
>> Computing the position after hists__link screws up the position data,
>> because we likely have new entries in.
>> 
>> However, I wonder if anyone is actualy using displacement info..?
>
> hum,
>
> the point of the displacement is to show how far is the matching entry
> in baseline wrt report output -> after hists__output_resort.. that goes
> in opposite way of what we try do to in here.
>
> Anyone else in favour of removing 'Displ.' column? ;-)

Oh, I somehow thought that the new dummy entries go into the baseline.
It's your change in the multi-diff patchset, not current code, right?

So we can change either the baseline to have dummies or skipping dummies
when computing their position.  Of course I have no objection to get rid
of the displacement logic completely too. :)

Thanks,
Namhyung
