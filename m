Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2GCScp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:32:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44529 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2GCScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <1341329631.2164.15.camel@joe2Laptop>
References: <1341264199.10162.2.camel@joe2Laptop>
	<1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1341310000-4082-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<1341329631.2164.15.camel@joe2Laptop>
Date: Tue, 3 Jul 2012 21:32:42 +0300
Message-ID: <CAHp75VfN4X9fH7NEUag3XYy7kLiEz-jcjhEOdoHMk3if_m_aOg@mail.gmail.com>
Subject: Re: [RFC][PATCHv2 2/3] lib: printf: append support of '%*p[Mm][FR]'
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 6:33 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-07-03 at 13:06 +0300, Andy Shevchenko wrote:
>> There are many places in the kernel where the drivers print small buffers as a
>> hex string. This patch adds a support of the variable width buffer to print it
>> as a hex string with a delimiter. The idea came from Pavel Roskin here:
>> http://www.digipedia.pl/usenet/thread/18835/17449/
>>
>> Sample output of
>>       pr_info("buf[%d:%d] %*pM\n", from, len, len, &buf[from]);
>> could be look like this:
>>       [ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
>>       [ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
>>       [ 0.757602] buf[17:5] ac:16:d5:2c:ef

> It might be more sensible to use new, distinct
> "%*pH" and "%*ph" functions and not touch the
> mac address function at all.  Will anyone ever
> really want to emit the buffer in reverse?
> I don't think so.
Yeah, probably it's only the case for the Bluetooth addresses.

> Perhaps when using a hex_string_buffer func the
> separator should be a space/no-space with %*pHh.
What I learned from today's linux-next is the most used separators are
' ' (space), '' (nothing), ':' and '-'. We have dozens of the cases
for first three. The '-' support could not be implemented
nevertheless.
So, might be %*pHh[CDS] C for 'colon', S for 'space', D for 'dash' looks better.
'Hh' for capital/small letters than?

> You could extend the max to 128 or larger now.
I don't think it is really needed. Most of the current cases usually
print not more than ~30bytes (in average) per time. And I couldn't
imagine good looking printing for long lines anyway.


-- 
With Best Regards,
Andy Shevchenko
