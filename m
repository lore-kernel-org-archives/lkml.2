Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab2ILOsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:48:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37772 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2ILOsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <1347461060.15764.44.camel@twins>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	<1347459195-5491-3-git-send-email-eranian@google.com>
	<1347459764.15764.32.camel@twins>
	<CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
	<1347461060.15764.44.camel@twins>
Date: Wed, 12 Sep 2012 16:48:04 +0200
Message-ID: <CABPqkBRRS7uz9kt-g8Rjj8K86AE+7U-emqKv1=tqcuRyqEk=Zw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 4:44 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 16:43 +0200, Stephane Eranian wrote:
>> The hrtimer_active is used to prevent activating the timer multiple times
>> in a row.
>
> see hrtimer_active(), this should do what you want I think.

I need something that is true even when the hrtimer is not executing
the callback handler. I guess that may be the different between
hrtimer_active() vs. hrtimer_running()?
