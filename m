Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1GVEtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 00:49:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39471 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1GVEtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 00:49:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110721143709.0c1e66d6.akpm@linux-foundation.org>
References: <1310951766-3840-1-git-send-email-akinobu.mita@gmail.com>
	<20110721143709.0c1e66d6.akpm@linux-foundation.org>
Date: Fri, 22 Jul 2011 13:49:09 +0900
Message-ID: <CAC5umyhscXSU6S6KAzawjsDvzrVjgA8RT7+DojVcLMX736QjUw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/22 Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 18 Jul 2011 10:16:01 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> This provides the ability to inject artifical errors to the following
>> notifier chain callbacks. It is useful to test the error handling of
>> notifier call chain failures.
>
> That all looks very nice, but I wonder how many people are actually
> using these things.  The injection framework itself doesn't seem to
> have had a lot of uptake.
>
> I wonder if we could improve things by adding an easy-to-run testing
> script which identifies all the available error-injection inputs,
> exercises them and then reports on the result?
>
> Such a script would logically reside under ./tests/fault-injection/,
> but we still don't have a tests/ directory.  Which perhaps tells us
> something ;)

Sounds goood. I'll create shell script that detects hot-pluggable CPU
or memory block and runs quick tests.

BTW, the patchset has been rewritten to be kernel modules rather than
initializing at late_initcall()s.  The reason for switching to kernel
modules is to provide an easy way to specify notifier priority as
module parameter.  I'll send newer patchset soon.
