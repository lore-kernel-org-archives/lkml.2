Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829Ab1E1EOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 00:14:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38695 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1E1EOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 00:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=x4BZdOmfXGoKKV34ZLNWoDjO5zxTgaRi38AxQevngUvudYe6JGhoCrckSTEpK1zoe0
         oTaxKh5Wx+E5B+k0THRP7dmnO27H/k0ALbpQv0uvavDA+IOX0otpCy+r6CmC5hoCZfdy
         m8NaWRSjiHjKrCWzmH5cf49lcbWwhlmn2Yjis=
MIME-Version: 1.0
In-Reply-To: <1306554793.11899.9.camel@gandalf.stny.rr.com>
References: <1306554793.11899.9.camel@gandalf.stny.rr.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 28 May 2011 00:14:25 -0400
X-Google-Sender-Auth: 8pJcPq0D7jsfrc73iUPmpD3oEaA
Message-ID: <BANLkTi=B4p6B3FmDwJ2HHjmAgcKGU0ARgA@mail.gmail.com>
Subject: Re: [GIT PULL] x86: Put back -pg to tsc.o and add no GCOV to vread_tsc_64.o
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:53 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Ingo,
>
> While running ktest randconfig tests on latest Linus's tree, I hit a
> case where the function graph tracer caused a nasty crash, or even a
> reboot. Using the ktest git bisect utility, I quickly found that the
> crash was due to the commit:
>
>  44259b1a x86-64: Move vread_tsc into a new file with sensible options
>
> I found that it removed the -pg from tsc.o causing accesses to tsc to be
> traced. The function graph tracer uses the tsc outside its recursive
> protection and this caused the crash.

Oops, I didn't think of that.

>
> But this was not the only bug. As I had 3 different configs that crashed
> in my randconfig tests, I tested all three. The first two ran fine with
> the update of the tsc.o with the -pg option, but the third config failed
> with the init process taking a segfault in the vread_tsc function.
>
> That same patch added the vread_tsc_64.o but did not disable GCOV from
> it. Thomas noticed that GCOV was set in that config and after disabling
> GCOV, the strange accesses to kernel space in that function went away.

And that was just an oversight on my part.  Sorry.

> Steven Rostedt (1):
>      x86: Put back -pg to tsc.o and add no GCOV to vread_tsc_64.o

Looks fine to me.

--Andy
