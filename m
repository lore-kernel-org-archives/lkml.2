Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2JOXGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:06:19 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35050 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2JOXGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121008211103.GK2631@ghostprotocols.net>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
 <1349678613-7045-9-git-send-email-irina.tirdea@gmail.com> <20121008211103.GK2631@ghostprotocols.net>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Tue, 16 Oct 2012 02:05:58 +0300
Message-ID: <CANg8OW+MSPmdnTKUuFk72Ef+nonw+BrfGXp=SYFqgA+Eq9-BqA@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] perf stat: implement --big-num grouping
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +     *gnumber = NULL;
>> +     /* No grouping */
>> +     if (thousands_sep == NULL || grouping == NULL ||
>> +         *thousands_sep == '\0' || *grouping == CHAR_MAX || *grouping <= 0) {
>> +             *gnumber = strdup(number);
>> +             if (*gnumber == NULL)
>> +                     ret = -ENOMEM;
>> +             goto out;
>
> Humm, so we bail out unconditionally? :-)
>
>         this should be:
>
>                 if (*gnumber == NULL)
>                         goto out;
>> +     }

The initial code was correct, although not clear. We bail out if there
is no grouping (the outer if), set gnumber to a copy of number and
return success. If we cannot allocate a copy of gnumber then we return
the error code.
However, this is no longer needed since it is already done when we
call the grouping function. So I'll just return error in case there is
no grouping and the calling code will take care to use the original
number (with no grouping).

I'll also fix your other comments and submit a new version.

Thanks,
Irina
