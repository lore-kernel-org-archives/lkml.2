Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2KUQfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:35:45 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37638 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2KUQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:35:44 -0500
MIME-Version: 1.0
In-Reply-To: <1352881898.9388.2.camel@joe-AO722>
References: <1352789457-15244-1-git-send-email-acooks@gmail.com>
	<1352881898.9388.2.camel@joe-AO722>
Date: Thu, 22 Nov 2012 00:35:42 +0800
Message-ID: <CAJtEV7aAe9bFtqCPdxQqr7FiErJ8G6-82Yog_bLXJL_3R_yNsA@mail.gmail.com>
Subject: Re: [PATCH] boot_delay should only affect output
From: Andrew Cooks <acooks@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe

On Wed, Nov 14, 2012 at 4:31 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-11-13 at 14:50 +0800, Andrew Cooks wrote:
>> The boot_delay parameter affects all printk(), even if the log level
>>  prevents visible output from the call. It results in delays greater
>>  than the user intended without purpose.
>>
>> This patch changes the behaviour of boot_delay to only delay output.
>
> Seems sensible.
>
> Couldn't that be done for printk_delay too?
>

This was only my second submitted patch, so I tried to keep things as
simple as possible to get the process right.

When printk_delay is called, the log message is written into a buffer
regardless of log level. The log level may change before the logs are
flushed to console/syslog, so delaying based on log level at the
buffer input side is not ideal.

I thought about moving the delay to the point where the buffer is
cleared, but that seems like it would drastically increase the
likelihood of dropping messages under load.

Dropping the message in vprintk_emit, before any delay or buffer
management might also be an option, though I'm not sure if it's
acceptable for printk to return 0.

a.
