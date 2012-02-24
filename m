Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2BXGhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:37:00 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51238 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab2BXGg7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:36:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.182.48.36 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F46E09C.2060403@lge.com>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	<20120223162850.GC25177@infradead.org>
	<CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
	<20120223163938.GD25177@infradead.org>
	<1330015504.13624.84.camel@jaguar>
	<20120223164739.GF25177@infradead.org>
	<20120223165302.GG25177@infradead.org>
	<CAOJsxLGP97smBEshzMY1vKMbSiK-mP1+dK8czuFM3girq-KS+A@mail.gmail.com>
	<20120223173743.GH25177@infradead.org>
	<alpine.LFD.2.02.1202231952410.6689@tux.localdomain>
	<4F46E09C.2060403@lge.com>
Date: Fri, 24 Feb 2012 08:36:58 +0200
X-Google-Sender-Auth: Tj6uQGJYQwSH2KpBYiEcFKf4C00
Message-ID: <CAOJsxLEGAEnx3EZr5cs2Y8eT-Phb16LrgKLnLaKG_P353gCoGQ@mail.gmail.com>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 2:58 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index e011b50..371f114 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -485,6 +485,20 @@ else
>>        endif
>>  endif
>>
>> +ifdef NO_GTK2
>> +       BASIC_CFLAGS += -DNO_GTK2
>
>
> s/-DNO_GTK2/-DNO_GTK2_SUPPORT/ ?

Fixed.

>> +       if (strcmp(report.input_name, "-") != 0) {
>> +               if (report.use_gtk)
>> +                       perf_gtk_setup_browser(argc, argv, true);
>> +               else
>> +                       setup_browser(true);
>> +       } else
>
>
> Wouldn't it be better if setup_browser() handled this internally based on
> the value of use_browser?

Well yes, but that requires some more code shuffling so I'd like to
leave it like that for now.

>> diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/util/gtk/browser.c
>> new file mode 100644
>> index 0000000..4878279
>> --- /dev/null
>> +++ b/tools/perf/util/gtk/browser.c
>
>
> I think it needs to be moved under util/ui. There will be some share point
> between tui and gui IMHO. Otherwise, if it is too much depends on TUI, how
> about rename util/ui to util/tui?

What's with you perf guys and deeply nested directory hierarchies? :-)

I think we should keep tools/ui but move the TUI specific bits out of
there. But as I said earlier, the code needs some work to support GTK
and TUI cleanly.

                         Pekka
