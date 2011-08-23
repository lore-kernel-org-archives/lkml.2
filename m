Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1HWS4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:56:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1HWS4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:56:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=hdegr5DpToN3GCsI/Aqd7t1rZahio027LDehdOU9S47VYpm4yFlA8Fjx3v5rpPtPI
	3braQWMoINcjo8rjaviVg==
MIME-Version: 1.0
In-Reply-To: <1314070027.15704.144.camel@gandalf.stny.rr.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
 <1313531179-9323-5-git-send-email-vnagarnaik@google.com> <1314070027.15704.144.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 23 Aug 2011 11:55:02 -0700
Message-ID: <CAL26m8LhwEDba5kmyDJ_-T7xPgDswHa9ORxSZwwLAW_KZ4Rr=Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 8:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-08-16 at 14:46 -0700, Vaibhav Nagarnaik wrote:
>> This patch adds the capability to remove pages from a ring buffer
>> without destroying any existing data in it.
>>
>> This is done by removing the pages after the tail page. This makes sure
>> that first all the empty pages in the ring buffer are removed. If the
>> head page is one in the list of pages to be removed, then the page after
>> the removed ones is made the head page. This removes the oldest data
>> from the ring buffer and keeps the latest data around to be read.
>>
>> To do this in a non-racey manner, tracing is stopped for a very short
>> time while the pages to be removed are identified and unlinked from the
>> ring buffer. The pages are freed after the tracing is restarted to
>> minimize the time needed to stop tracing.
>>
>> The context in which the pages from the per-cpu ring buffer are removed
>> runs on the respective CPU. This minimizes the events not traced to only
>> NMI trace contexts.
>
> Could you do the same with this patch, as this one fails to build as
> well. And probably should check patch 5 while your at it.
>
> -- Steve
>

I have corrected both the patches. I will make sure that I add
'allyesconfig' and 'allnoconfig' build targets also in my work flow to
avoid such issues.


Vaibhav Nagarnaik
