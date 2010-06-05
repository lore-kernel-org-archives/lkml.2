Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0FEJhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 05:37:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56522 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab0FEJhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 05:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BIeW5mSL1saByZwc7c6Vz/cS/iOu7Daq0CV1j47FFvHo7L2Pv4j68DiKGOZkXyZnaa
         pw9twuWwJSGfrdtTQlrHgpErxrftja01dqOHc/wYeF1Yb7JpwE/bwiOcXpnfejpuUX5f
         138TzUKgqYPRUHT+/+qkfSUR79b8kvUEZAgY0=
MIME-Version: 1.0
In-Reply-To: <1275652843.27810.39750.camel@twins>
References: <20100520204810.GA19188@think>
	<AANLkTinifUTnjypY-h6Vv2qV9O7O4ZOFurxtrEr-3Rig@mail.gmail.com>
	<1275652843.27810.39750.camel@twins>
Date: Sat, 5 Jun 2010 11:37:09 +0200
Message-ID: <AANLkTikomDB_9v7G5baRszSZiV3mydDmIuYZm78r0P6d@mail.gmail.com>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Stijn Devriendt <highguy@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 2:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-06-04 at 12:56 +0200, Stijn Devriendt wrote:
>
>> The issue I want to tackle is waking up processes when others go to sleep.
>> This means try_to_wake_up() from inside the runqueue lock.
>
>
> Tejun did something for that:
>
>  http://lkml.org/lkml/2010/5/13/136
>
>
>

The difference with what I have is that Tejun's threads are guaranteed
to be local
and on the same CPU/runqueue avoiding runqueue deadlocks. My code can be
used to wake up any thread as I basically defer waking up untill after
the runqueue
lock is released.
