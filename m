Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1JBAV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 20:21:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35428 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1JBAVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 20:21:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAA879TPzmVh4yR5n4Mfd8D6ERpvAFipeMXr1QBr3fwQMdvnRzw@mail.gmail.com>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
 <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com> <CAA879TPzmVh4yR5n4Mfd8D6ERpvAFipeMXr1QBr3fwQMdvnRzw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Oct 2011 17:20:58 -0700
X-Google-Sender-Auth: -mdO2dTahFhM_q6RA2fNhmj6sfQ
Message-ID: <CA+55aFyci1PB9Y_BSqWnQKSSfcCrbJud+q1Z8Cdquo7hXJZaMw@mail.gmail.com>
Subject: Re: taskstats root only breaking iotop
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 3:41 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
> On Sat, Oct 1, 2011 at 11:59 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> I think the question should be: why is it *ever* a good idea to let
>> *anybody* read how many bytes anybody has read.
>
> I use iotop to get the throughput of a cp or tar because I don't
> always think of piping to 'pv'. People also use it as a progress
> indicator for their less verbose applications (total bytes
> read/written instead of rate).

I can understand the use of "throughput".

I don't understand why you then even *mention* byte-granularity. NOBODY CARES.

It really is that simple. Either you care about a single process (and
you damn well use strace or something similar), or you care about
"statistics".

For the statistics, something *like* TASKSTATS can make sense, but
never *ever* does it make sense to give byte-granularity stats in that
case.

So I don't see why you ask for it. What could possibly be a valid use-case?

                         Linus
