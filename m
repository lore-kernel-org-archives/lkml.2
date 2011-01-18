Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1ARI7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 03:59:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46010 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1ARI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 03:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kveTsM5YNKa9NDv25QitjS52mkuVmT7XzTsqmhTWoAfnxYQi3E9tf2W7Nxyb6vfsny
         cgFl2rJ+PIrzHsk5NZPCzzRRB5ngthG3CsYEbz2MaIqzgrEUJzfHxZHOTYZGUfhIRF2m
         fONwXKTbuKh0osHNF/FM5EZtaKBbaw9T+Rq8g=
MIME-Version: 1.0
In-Reply-To: <1295339012.11678.35.camel@kolo>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
Date: Tue, 18 Jan 2011 16:59:04 +0800
Message-ID: <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: samu.p.onkalo@nokia.com
Cc: ext Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 4:23 PM, Onkalo Samu <samu.p.onkalo@nokia.com> wrote:
> On Mon, 2011-01-17 at 17:00 +0100, ext Peter Zijlstra wrote:
>> On Mon, 2011-01-17 at 16:42 +0200, Onkalo Samu wrote:
>> >
>> > Failure case:
>> > - user process locks rt_mutex
>> > - and goes to sleep (wait_for_completion etc.)
>> > - user process is dequeued to sleep state
>> > -> vruntime is not updated in dequeue_entity
>> >
>>
>> Does the below (completely untested) patch help?
>
> Unfortunately no.

It couldn't work because place_entity() will not place it
backwards.


-- 
Only stand for myself
