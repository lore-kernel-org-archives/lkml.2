Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2JPTkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:40:19 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52935 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab2JPTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAAZUjxAPAUD50asniJVNgD3X=vM_d=GPKJ5C2eVGo6r4HUKYLQ@mail.gmail.com>
References: <CAAZUjxCvK0QnwnZP_FBiO2JM1rMoEA3HLjKAcYD14cxdGWyg4Q@mail.gmail.com>
 <507DB47E.5090003@mit.edu> <CAAZUjxAPAUD50asniJVNgD3X=vM_d=GPKJ5C2eVGo6r4HUKYLQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Oct 2012 12:39:55 -0700
Message-ID: <CALCETrVKiO5t8AuEM=XxdPgZGr6crr6C-4174607_VLO787--g@mail.gmail.com>
Subject: Re: VDSO gettimeofday() x86_64 linux 3.2
To: wilson self <wself00@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:33 PM, wilson self <wself00@gmail.com> wrote:
> current_clocksource is tsc.
>
> the entire source of the test application:
> ---
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/time.h>
> #include <time.h>
>
> int main() {
>       struct timeval tim;
>       gettimeofday(&tim, NULL);
>       printf("%.6lf seconds\n", tim.tv_sec+tim.tv_usec/1000000.0);
> }
> ---
> nothing fancy going on here.
>
> thanks for the help.

There's lots of hidden fanciness.  What glibc version are you using
and how are you linking to glibc?  All but the newest glibc versions
use the old vsyscall when statically linked.  The newest versions use
the syscall instead.  If you're dynamically linking, then gettimeofday
should be okay even with fairly old glibc versions.

(FWIW, glibc maintainership has changed since this was decided.  Feel
free to bug the new maintainers if you care about statically-linked
performance.  The only other runtime library I know of that uses the
vdso or vsyscalls is Go, and the newest versions do the right thing.)

--Andy
