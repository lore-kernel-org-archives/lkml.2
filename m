Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab1F1QkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:40:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16597 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631Ab1F1Qiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:38:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=Avl6dFy8YoOnWfrX2Nnr9C8g+5Id1ZhL0/YtFjorOpI3hQLCwNnuQqu5ii8rfrcHt
	66MycvoCnNZ+L5+RXkDUw==
MIME-Version: 1.0
In-Reply-To: <BANLkTimhEE6TXqnS+eLx863+rjJxqzu19A@mail.gmail.com>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
	<1309224113-21818-4-git-send-email-sergiu@chromium.org>
	<BANLkTimhEE6TXqnS+eLx863+rjJxqzu19A@mail.gmail.com>
Date: Tue, 28 Jun 2011 09:38:44 -0700
Message-ID: <BANLkTiniM96M16TnPC9sXNg-rhDD1RT4KOcD1HJUH-Nu+7hY2Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] char drivers: ramoops record_size module parameter
From: Sergiu Iordache <sergiu@google.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 11:39 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Hi,
>
> 2011/6/28 Sergiu Iordache <sergiu@chromium.org>:
>> The size of the dump is currently set using the RECORD_SIZE macro which
>> is set to a page size. This patch makes the record size a module
>> parameter and allows it to be set through platform data as well to allow
>> larger dumps if needed.
>>
>> Change-Id: Ie6bd28a898dab476abf34decb0eecc42122f17ce
>> Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
>> ---
>
> the idea can be valid, but you have to add some check to set the
> record size. It'd be better to add a lower and upper bound and to
> check for it's power of two.

That sounds like a good idea. Since the memory size gets rounded to a
power of two it would probably be more consistent to round down the
record size as well. This way you would be sure that mem_size is a
multiple of record size as well. The upper bound would be the memory
size, which is already checked. I'm not sure whether it would be a
good idea to add lower bound different from record_size != 0 (I don't
know why someone would need to dump 8 bytes for example but is there a
reason to limit it?)

Sergiu
