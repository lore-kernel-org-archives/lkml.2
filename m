Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0KILH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:07:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41178 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0KILHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=TevMsnTKrcM0QfFAmMPE0i8+jhyEi6DJd/HJZ6uJeWfGNI8CcD+yefYBpt0yGANEap
         0DI/kfOYABBaUvAgw1Ns7iK7uC+H/4TpQhn2hL6HPX3Ah2/42HIzANUYiTR9sa11pncv
         JBnpylWeAt8OpaCnPEZT79eFQujN0f0Z2jLyY=
From: Francis Moreau <francis.moro@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.yHA7Aw03llqLWxPVYRnHvK5/dT8@ifi.uio.no>
	<fa.13KEqWk+Dk+jLLdFlAoZtQ2Vjuw@ifi.uio.no> <m2lj59sc7a.fsf@gmail.com>
	<20101107214025.GD11134@nowhere>
Date: Tue, 09 Nov 2010 12:07:12 +0100
In-Reply-To: <20101107214025.GD11134@nowhere> (Frederic Weisbecker's message
	of "Sun, 7 Nov 2010 22:40:27 +0100")
Message-ID: <m2y692vjq7.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Thu, Nov 04, 2010 at 09:52:09AM +0100, Francis Moreau wrote:

[...]

>> 
>> No problem, but yes this part should be documented somewhere. And I
>> think the syntax of event too, specially the modifier like 'u' or 'p'.
>
> Ah that is documented in "man perf-list".

Ok, after updating my 3 weeks old kernel, modifiers are now documented.

But I failed to generate it:

    XMLTO perf-record.1
xmlto: /home/fmoreau/linux-2.6/tools/perf/Documentation/perf-record.xml does not validate (status 3)

BTW, what does 'skid' mean ? s(?) k(?) instruction delay ?

[...]

> I have the same problem. But running perf record with this :p works
> for me. Which is what we want: pebs is useful for sampling, not
> counting-only.

That makes sense but I still have a problem:

   $ perf record -e cache-misses:p -p $(pgrep test)

  Error: perfcounter syscall returned with -1 (No space left on device)

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?


> Ah and that won't work if you don't run some intel CPU I think.  Check
> you have PEBS support in /proc/cpuinfo

It seems so:

   $ grep -qi pebs /proc/cpuinfo && echo pebs
   pebs

Thanks
-- 
Francis
