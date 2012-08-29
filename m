Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2H2Q7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:59:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2H2Q7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:59:15 -0400
Message-ID: <503E4A58.5000000@gmail.com>
Date: Wed, 29 Aug 2012 10:59:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 12/13] perf tools: replace on_exit with atexit
References: <CANg8OW+q0VumrJrQL57gecO0W0TrpB_WgspKhM-GeiPEdiSPDQ@mail.gmail.com>
In-Reply-To: <CANg8OW+q0VumrJrQL57gecO0W0TrpB_WgspKhM-GeiPEdiSPDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/12 4:06 PM, Irina Tirdea wrote:
> on_exit() is only available in new versions of glibc.
> Using on_exit on Android leads to errors at compile time.
>
> Replacing on_exit with its more portable version atexit.
> This leads to using a global variable since on_exit supports
> sending a parameters while atexit does not.

Bernhard's patch implements on_exit. Why not go that route?

The exit functions need the commands status to know whether to attempt 
to process records. See: https://lkml.org/lkml/2012/8/26/123

Processing records on non-0 exit causes a segfault as the session has 
been deleted.

David

