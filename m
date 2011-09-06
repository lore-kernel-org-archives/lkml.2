Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1IFS5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:57:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1IFS5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:57:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jyfsYntq27R2quPej3iRwA7D4dpeEh6pqfwL1QERVSj8xaKmC4PJY4Pew0wtBOVNw
	q+k+XwN4cENbpiB0CU9EQ==
MIME-Version: 1.0
In-Reply-To: <1315017933.21100.55.camel@gandalf.stny.rr.com>
References: <1313531179-9323-4-git-send-email-vnagarnaik@google.com>
 <1314062244-2997-1-git-send-email-vnagarnaik@google.com> <1315017933.21100.55.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 6 Sep 2011 11:56:30 -0700
Message-ID: <CAL26m8K8fusTUyvn_XwBs0OMoxMexG+t=M4kR3sWEOkc3rWOKQ@mail.gmail.com>
Subject: Re: [PATCH v3] trace: Add per_cpu ring buffer control files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 7:45 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-08-22 at 18:17 -0700, Vaibhav Nagarnaik wrote:
>> +     /* ring buffer pages to update, > 0 to add, < 0 to remove */
>> +     int                             nr_pages_to_update;
>> +     struct list_head                new_pages; /* new pages to add */
>
> There's no reason for the added new_pages. And I'm not sure I even like
> the 'nr_pages_to_update' either. These are only used for resizing and
> are just wasting space otherwise.
>
> You could allocate an array of numbers for the nr_pages_to_update and
> use that instead. As for the list, heck, you can still use a single list
> and pass that around like the original code did.
>

In this patch's context, I could still use the same logic of having a
temporary list of new pages and passing the nr_pages_to_update as a
parameter to the function. However, this comes in handy when considering
the next 2 patches. The updates are meant to be per_cpu and so having
separate list of new pages is better to handle. Same thing with
nr_pages_to_update.

>> +                             update_pages_handler(cpu_buffer);
>> +                             cpu_buffer->nr_pages = nr_pages;
>
> The two places that call update_pages_handler() also updates
> cpu_buffer->nr_pages. Move that to the update_pages_handler() as well.

Sure. I will update that.

> I'm still very nervous about this patch. I'm going to hold off a release
> cycle before even giving it up to Ingo.

Sure. I agree that the patches need a rigorous review and your
confidence in them is a necessary element.

I am working on other projects now, so I might have a slower response
time. But I will try to update the patch and send it to you in a timely
manner.


Vaibhav Nagarnaik
