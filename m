Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1GGWey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:34:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1368 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1GGWev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:34:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=NNID6Q1Jnhh9HtdicwWs23uLBUy1nf9wYIarFoyyl+9e8i1oujw4m5szY3PIa70qa
	1IrD01ovgkIZ6dLc0L2og==
MIME-Version: 1.0
In-Reply-To: <20110707130130.8dd02f01.akpm@linux-foundation.org>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
 <1309994990-4729-4-git-send-email-sergiu@chromium.org> <20110707130130.8dd02f01.akpm@linux-foundation.org>
From: Sergiu Iordache <sergiu@chromium.org>
Date: Thu, 7 Jul 2011 15:34:26 -0700
X-Google-Sender-Auth: VGBorXNuXGizOkU0LZnHcDgewMk
Message-ID: <CAGDaqBQMp0xyBF7Z=P5qBqNcceG3JfWNEUX=T=yMZH74UP5kxA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] char drivers: ramoops debugfs entry
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 1:01 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  6 Jul 2011 16:29:50 -0700
> Sergiu Iordache <sergiu@chromium.org> wrote:
>
>> While ramoops writes to ram, accessing the dump requires using /dev/mem
>> and knowing the memory location (or a similar solution). This patch
>> provides a debugfs interface through which the respective memory
>> area can be easily accessed.
>>
>> The entry added is /sys/kernel/debug/ramoops/next
>>
>> The entry returns a dump of size record_size each time, skipping invalid
>> dumps. When it reaches the end of the memory area reserved for dumps it
>> returns an empty record and resets the current record count.
>
> The patch increases the size of ramoops.o text&data from 1725 bytes to
> 2282 even when CONFIG_DEBUG_FS=n.  That's quite a lot of bloat!
>
> Furthermore, I think debugfs is the wrong place to put this.  debugfs
> is, umm, for debugging.  It's a place in which to put transitory junk
> which may or may not be there and where interfaces may change without
> notice and whose presence userspace should not assume.  But in this
> patch you're proposing a permanent and formal new interface into the
> ramoops driver.  It should go into a permanent well-known place where
> it will be maintained with the formality and care of all the other
> parts of the kernel API.
How about not using the debugfs entry and adding a char driver? There
are 2 possibilities here as well: using read operations to return the
data like the current patch does or using ioctl to return the data(and
maybe return other info as well such as the records size and the
memory size). Any suggestions regarding a valid approach?

> Also, you're proposing a new kernel/userspace API but it wasn't
> documented anywhere.  We don't want to have to reverse-engineer your
> proposed API from the implementation for review purposes.  That API
> should have been exhaustively documented in the changelog so others can
> decide whether they like it.
>
> Finally, we should provide user documentation for the new interface so
> others can find out that it exists and can use it correctly.  We seem
> not to have bothered documenting ramoops so we don't currently have a
> context in which to do this.
I'll create some documentation for both the (future) API and the ramoops module.

Sergiu
