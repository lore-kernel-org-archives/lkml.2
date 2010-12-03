Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0LCGFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:05:07 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37808 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0LCGFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:05:04 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/4] perf tools: Ask for ID PERF_SAMPLE_ info on all PERF_RECORD_ events
From: Ian Munsie <imunsie@au1.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
In-reply-to: <1291318772-30880-5-git-send-email-acme@infradead.org>
References: <1291318772-30880-1-git-send-email-acme@infradead.org> <1291318772-30880-5-git-send-email-acme@infradead.org>
Date: Fri, 03 Dec 2010 17:04:55 +1100
Message-Id: <1291355205-sup-6543@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Arnaldo Carvalho de Melo's message of Fri Dec 03 06:39:32 +1100 2010:
> +-T::
> +--timestamp::
> +    Sample timestamps. Use it with 'perf report -D' to see the timestamps,
> +    for instance.
> +

I'm of two minds about allowing the user to request this. My patches
will enable this by default if sampling from multiple CPUs, which is the
norm unless no_inherit is specified, so this option will not have any
affect unless sampling from a single CPU as well.

> +            } else if (err == EINVAL && sample_id_all_avail) {
> +                /*
> +                 * Old kernel, no attr->sample_id_type_all field
> +                 */
> +                sample_id_all_avail = false;
> +                goto retry_sample_id;

Should we warn the user here? I guess the warning applies more to my
patches then these though, since I'm fixing a bug whereas you are just
adding a new feature, and samples will still have timestamps in your
patches either way.

> +        printf("%Lu ", sample->time);

A little off topic, but I've noticed this in a few places throughout the
perf code - the L length modifier in printf is for a long double, not a
long long int (which is ll). The fact that this works with glibc is a
bug (and we've seen how little sympathy the glibc developers have for
programs not using glibc as per the standard). See the note in
CONFORMING TO in the printf man page.

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
