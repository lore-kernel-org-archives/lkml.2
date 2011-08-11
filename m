Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1HKUbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:31:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1HKUbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:31:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=iHsiq3DOYFoTUnXSd5Em4/bp/xyfB9u4fw0UXw1ggIgNscnOku2vAUaH830R2MCnn
	aiiUgr8hzAK1l65iJUxRQ==
MIME-Version: 1.0
In-Reply-To: <1313094223.26866.15.camel@twins>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	<1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	<1313091323.8491.30.camel@twins>
	<CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
	<1313094223.26866.15.camel@twins>
Date: Thu, 11 Aug 2011 13:31:13 -0700
X-Google-Sender-Auth: YmVWWdBbB-C6RElh7RQ7owNMG3A
Message-ID: <CAAuSN90CXXEdco_fNYrv-ZUZPr4nB4HYPM1NCgaSgGz+Z-jaRQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Alex Neronskiy <zakmagnus@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 1:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-08-11 at 13:10 -0700, Alex Neronskiy wrote:
> Ah, right, yeah, stick another lock in there.. One does worry about the
> whole writer concurrency thing though, isn't it likely all cpus will
> tickle the thing in quick succession? Putting a global lock in that path
> isn't good,.. always think of the poor sod with the 4096 cpu machine.
Is it common to disable interrupts on all 4096 CPU's at once?

> Also, is all of this really useful? The hardlockup watchdog is useful
> when you mess up bad, but other than that I've never found it to be
> useful at all.
>
> I mean, we're at the point where a PREEMPT=y kernel has a pretty decent
> latency and the PREEMPT_RT kernels live at ~30us. So wth are you
> measuring?
Well, not all kernels have PREEMPT. Chromebook kernels don't, for example.
