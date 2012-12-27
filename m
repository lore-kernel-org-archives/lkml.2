Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2L0TJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 14:09:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab2L0TJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 14:09:38 -0500
Message-ID: <50DC9CE1.9030709@redhat.com>
Date: Thu, 27 Dec 2012 14:09:21 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jan Beulich <jbeulich@suse.com>
CC: eric.dumazet@gmail.com, rostedt@goodmis.org, therbert@google.com,
        walken@google.com, jeremy@goop.org, tglx@linutronix.de,
        aquini@redhat.com, lwoodman@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185147.4ae48ab5@annuminas.surriel.com> <20121221185613.1f4c9523@annuminas.surriel.com> <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com> <1356549008.20133.20856.camel@edumazet-glaptop> <50DB5531.90500@redhat.com> <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com> <1356618448.30414.948.camel@edumazet-glaptop> <50DC5CC0.6010003@redhat.com> <50DC9662020000780009210D@nat28.tlf.novell.com>
In-Reply-To: <50DC9662020000780009210D@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 01:41 PM, Jan Beulich wrote:
>>>> Rik van Riel <riel@redhat.com> 12/27/12 4:01 PM >>>
>> On 12/27/2012 09:27 AM, Eric Dumazet wrote:
>>> So the hash sounds good to me, because the hash key could mix both lock
>>> address and caller IP ( __builtin_return_address(1) in
>>> ticket_spin_lock_wait())
>>
>> The lock acquisition time depends on the holder of the lock,
>> and what the CPUs ahead of us in line will do with the lock,
>> not on the caller IP of the spinner.
>
> The lock holder could supply its __builtin_return_address(0) for use
> in eventual hashing.
>
> Also, with all of this - did you evaluate the alternative of using
> monitor/mwait instead?

How much bus traffic do monitor/mwait cause behind the scenes?

-- 
All rights reversed
