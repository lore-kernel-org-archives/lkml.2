Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2I3XlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:41:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54078 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2I3XlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <1348824728-14025-12-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org> <1348824728-14025-12-git-send-email-namhyung@kernel.org>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Mon, 1 Oct 2012 02:40:55 +0300
Message-ID: <CANg8OWL1ii9onSA3KDvYQ2Chm5=RcN9AnZebuXe12RSmoR29vw@mail.gmail.com>
Subject: Re: [PATCH 11/12] perf tools: Convert to BACKTRACE_SUPPORT
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -751,10 +753,8 @@ else
>  endif
>
>  ifdef NO_BACKTRACE

This should be changed to ifndef NO_BACKTRACE.

> -       BASIC_CFLAGS += -DNO_BACKTRACE
> -else
> -       ifneq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
> -               BASIC_CFLAGS += -DNO_BACKTRACE
> +       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
> +               BASIC_CFLAGS += -DBACKTRACE_SUPPORT
>         endif
>  endif
>

Thanks,
Irina
