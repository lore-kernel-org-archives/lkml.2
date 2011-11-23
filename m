Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1KWKKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:10:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42616 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KWKKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:10:16 -0500
MIME-Version: 1.0
In-Reply-To: <1322042767.14799.25.camel@twins>
References: <20111116145320.GA20146@quad>
	<1321958457.5148.17.camel@twins>
	<CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
	<1321968559.14799.2.camel@twins>
	<CABPqkBTWqPNhMBEsLmto+3=2FYjyy_b2hzq2KLbKWDFSKNktsg@mail.gmail.com>
	<1322042767.14799.25.camel@twins>
Date: Wed, 23 Nov 2011 11:10:15 +0100
Message-ID: <CABPqkBRE6bH8WV1ZMeUKrEuF3D4M8WymxzkZOOjsnbya-cOSYg@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event sampling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-11-23 at 10:30 +0100, Stephane Eranian wrote:
>>
>> In the case of perf_event, we are not in a producer-consumer model, so
>> it seems like the behavior we have now is correct. The caller of poll()
>> gets stuck if the file descriptor is closed.
>
> But wouldn't out event->waitq still be referenced by that waiting task?
> Even though we freed it in our fops->release() callback?
>
I suspect you don't end up in fops->release() if you have an ongoing poll
because you've probably increment the file's refcount along the way.
