Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab0JXRDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 13:03:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:55277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822Ab0JXRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 13:03:48 -0400
Date: Sun, 24 Oct 2010 10:03:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: perf timechart segfault
Message-ID: <20101024100356.7af1f4dd@infradead.org>
In-Reply-To: <20101024162302.GA5586@sucs.org>
References: <20101024162302.GA5586@sucs.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010 17:23:02 +0100
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Hi,
> 
> I've run into a couple of issues using perf timechart:
> 
> 1. (On 2.6.36) If I issue
>    echo 0 > /proc/sys/kernel/perf_event_paranoid
>    as root before running
>    perf timechart record echo
>    as a normal user the following is printed:
> 
>    Fatal: Permission error - are you root?
>   	 Consider tweaking /proc/sys/kernel/perf_event_paranoid.
> 
>    Shouldn't it just say it needs root permissions for a timechart
>    record?

timechart needs root perms since it gets very global data.

> 
> 2. (On -tip) Running
>    perf timechart record echo
>    outputs
>    invalid or unsupported event: 'power:power_start'
>    Run 'perf list' for a list of valid events

tip broke ABI :-(
That's one for Ingo to deal with for now.

> 
> 3. (On 2.6.36) I can't seem to convince timechart to ever capture more
>    than 34000 samples. When trying to record using
>    perf timechart record -fga sleep 10
>    and then creating a graph using perf timechart, it only ever
> outputs a few seconds worth.

does this happen even without the "fga" ?
I've used timechart to capture a minute of data before
(but... you need a rather quiet system for that to be useful.... you
otherwise get an impossibly big SVG file)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
