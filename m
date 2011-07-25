Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1GYU2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:28:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34130 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1GYU2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <1311625197.3526.35.camel@gandalf.stny.rr.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	<1311625197.3526.35.camel@gandalf.stny.rr.com>
Date: Mon, 25 Jul 2011 16:28:33 -0400
Message-ID: <CACqU3MW3+Ph9GgL0b4y+RZ2Ak99XxNuNqzayuXXwVCFs8=ijxw@mail.gmail.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 4:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-07-25 at 15:43 -0400, Arnaud Lacombe wrote:
>
>> Actually, we have a special uninitialized_var(x) macro to handle such
>> false positive. From include/linux/compiler-gcc.h:
>>
>> /*
>>  * A trick to suppress uninitialized variable warning without generating any
>>  * code
>>  */
>> #define uninitialized_var(x) x = x
>
> I'm aware of that too, but I think that is inappropriate as well. As I
> said, some versions of gcc report it, others don't. Seems that gcc 4.6.0
> says this is an error where 4.5.1 does not (I just tried both). Looks to
> me like a regression in gcc. Why not fix it there?
>
It should, but gcc 4.6.x has already been shipped out there, so we
will have to live with that for a while. Marking this as a false
positive now will avoid having multiple submission for this in the
future.

 - Arnaud

> -- Steve
>
>
>
