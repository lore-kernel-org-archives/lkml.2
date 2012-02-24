Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab2BXKF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:05:58 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37827 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703Ab2BXKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:05:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.60.29.34 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224094812.GF814@elte.hu>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	<1330025802.17301.1.camel@lenny>
	<CAOJsxLEQ0VNsTEApsWQHC4G4199xm31UkWt1n0fqh3tZVa2f8A@mail.gmail.com>
	<1330029238.17301.3.camel@lenny>
	<CAOJsxLEksW5Jn=xF+mFmKswRDny+ZfBTYRYUarzn_fmNcpk_OQ@mail.gmail.com>
	<20120224094812.GF814@elte.hu>
Date: Fri, 24 Feb 2012 12:05:56 +0200
X-Google-Sender-Auth: LgOsSg5keDvGXuDZ32xhEQi7wjw
Message-ID: <CAOJsxLFv=Pq0iHrUQsK7gghhrmwBB=BqzY--RhisbjUZuLMEyg@mail.gmail.com>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Colin Walters <walters@verbum.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 11:48 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Pekka Enberg <penberg@kernel.org> wrote:
>
>> On Thu, Feb 23, 2012 at 10:33 PM, Colin Walters <walters@verbum.org> wrote:
>> >> Sure. We don't want to do that for all files. Just for the ones that
>> >> include <gtk/gtk.h>.
>> >
>> > #pragma GCC diagnostic push
>> > #pragma GCC diagnostic ignored "-Wstrict-prototypes"
>> > #include <gtk/gtk.h>
>> > #pragma GCC diagnostic pop
>>
>> It's cleaner to do it at Makefile level. We should do
>> something like sparse.git Makefile does where you can
>> optionally specify CFLAGS for individual source files.
>
> I actually like the #pragma hack because it only turns off the
> check for that broken header and keeps our checks in place for
> the rest of the .c file.
>
> Could be turned into a util/gtk.h file that is included instead
> of <gtk/gtk.h>, so that we don't have to see the #pragma
> workaround all the time?

Sure, makes sense.
