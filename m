Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1G2TO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:14:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1G2TO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:14:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=Svd7rVKbyV2SODlatcoUyuhkq7oKYuo0vLn3x1oMWBZpLrkwJjd9N93G9Oc9fJj1s
	+KmIhJv9ttdfFbt/lsWFQ==
MIME-Version: 1.0
In-Reply-To: <1311963247.21143.76.camel@gandalf.stny.rr.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
 <1311721194-12164-4-git-send-email-vnagarnaik@google.com> <1311963247.21143.76.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Jul 2011 12:13:53 -0700
Message-ID: <CAL26m8Jb-PO7z0+gcwhkxB0q36pA7Fe9Tz=Pimq8kua8yahvgA@mail.gmail.com>
Subject: Re: [PATCH 3/5] trace: Add per_cpu ring buffer control files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 11:14 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:
>> Add a debugfs entry under per_cpu/ folder for each cpu called
>> buffer_size_kb to control the ring buffer size for each CPU
>> independently.
>>
>> If the global file buffer_size_kb is used to set size, the individual
>> ring buffers will be adjusted to the given size. The buffer_size_kb will
>> report the common size to maintain backward compatibility.
>>
>> If the buffer_size_kb file under the per_cpu/ directory is used to
>> change buffer size for a specific CPU, only the size of the respective
>> ring buffer is updated. When tracing/buffer_size_kb is read, it reports
>> the ring buffer sizes of all the CPUs at that point.
>
> No, buffer_size_kb should not change in the what it reports. This is why
> you have a buffer_total_size_kb. Use that. If the per_cpu buffers are
> changed, then this should just report "various" or something to that
> affect. This will be a good way to know if the per_cpu buffers are the
> same or not.

Aargh.

I updated the code to return 'X' when individual cpu buffers don't match
up in size and forgot to update the changelog, I will do it now.


Vaibhav Nagarnaik
