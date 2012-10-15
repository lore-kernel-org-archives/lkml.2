Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2JOW72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:59:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48508 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2JOW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:59:26 -0400
MIME-Version: 1.0
In-Reply-To: <20121008210312.GI2631@ghostprotocols.net>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
 <1349678613-7045-7-git-send-email-irina.tirdea@gmail.com> <20121008210312.GI2631@ghostprotocols.net>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Tue, 16 Oct 2012 01:59:06 +0300
Message-ID: <CANg8OWLttdHHbmaDD7smJBXCd0oYLigrwjLrVu8ohH2Co-yx+g@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] perf tools: Try to find cross-built objdump path
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> +     if (!objdump_path)
>> +             try_objdump_path(session);
>
> Please do the test on perf_session_env__lookup_objdump() and handle
> errors, i.e. what happens if that strdup/asprintf fails?
>
> Ok, that is unlikely, but not impossible, but what happens if we don't
> find the right objdump? Shouldn't we use ui__error("please install
> required objdump" (or a better, more detailed message)?
>

My initial intention was to use the default "objdump" in case of any
error. On second though, this should not be allowed since the data was
recorded on a different architecture. I'll print error messages
instead.

Thanks,
Irina
