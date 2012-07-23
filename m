Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2GWUso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:48:44 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45040 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2GWUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120723203120.GA25072@shutemov.name>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
 <1343055645-24083-2-git-send-email-kirill@shutemov.name> <CAOPLpQe7=Gv7ToM8cqe1rNCP+vX5=gVppA1=gfaO0LSdqMhqMQ@mail.gmail.com>
 <20120723203120.GA25072@shutemov.name>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 23 Jul 2012 16:48:22 -0400
Message-ID: <CAOPLpQdcSw6KGT=odFSAUScd44mUdkYpR6hQM_zg81Y88T=VHg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: use XSI-complaint version of strerror_r()
 instead of GNU-specific
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 4:31 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> +               const char *err = strerror_r(errnum, buf, buflen);
> +
> +               if (err != buf && buflen > 0) {
> +                       size_t len = strlen(err);
> +                       char *c = mempcpy(buf, err, min(buflen - 1, len));
> +                       *c = '\0';
> +               }

No need to check for err == NULL.   buflen == 0 is a possibility given
the interface but I'd say this is an error and should be tested for at
the beginning of the function and the call should fail or even abort
the program.
