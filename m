Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2EJQFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:05:33 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39129 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab2EJQFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:05:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120510114520.GA10111@mwanda>
References: <1336004981.4240.10.camel@mop> <20120510114520.GA10111@mwanda>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 09:05:09 -0700
X-Google-Sender-Auth: 0Fi9_QNqeFv7FEGqqaAOqt5u5Rs
Message-ID: <CA+55aFyg7z5Fn04aY6Kczru5ZnwXeHNV8EZU=J4p4wGxZVChJw@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/3] kmsg: export printk records to the /dev/kmsg interface
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 4:45 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, May 03, 2012 at 02:29:41AM +0200, Kay Sievers wrote:
>> +     /* escape non-printable characters */
>> +     for (i = 0; i < msg->text_len; i++) {
>> +             char c = log_text(msg)[i];
>> +
>> +             if (c < ' ' || c >= 128)
>
> Signed char type is never larger than 127.

You don't know that it's signed.

The sign of "char" is implementation-defined, and there are indeed
architectures that Linux supports where it is unsigned (I think ARM is
one example).

So that comparison against 128 is actually required.

Or, better yet, the code should make 'c' *explicitly* signed (or
unsigned) so that this particular C language definition oddity is
avoided entirely.

               Linus
