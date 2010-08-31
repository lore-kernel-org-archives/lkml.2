Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0HaBLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:11:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41470 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab0HaBLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:11:00 -0400
MIME-Version: 1.0
X-Originating-IP: [192.55.54.36]
In-Reply-To: <tip-fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1@git.kernel.org>
References: <4c76802d.aae9d80a.115d.70fe@mx.google.com>
	<tip-fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1@git.kernel.org>
Date: Tue, 31 Aug 2010 09:10:59 +0800
Message-ID: <AANLkTikJMMn5gPwkBJcL7=KYR5wK-DKW=mqoR6Ks0jRH@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf_events: Fix time tracking for events with
 pid != -1 and cpu != -1
From: Lin Ming <lin@ming.vg>
To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, eranian@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> perf_events: Fix time tracking for events with pid != -1 and cpu != -1

Hi,

I thought pid != -1 and cpu != -1 is not valid.

# perf top -p 23268 -C 1
WARNING: PID switch overriding CPU

In which case this could be valid?

Thanks,
Lin Ming

>
> Per-thread events with a cpu filter, i.e., cpu != -1, were not
> reporting correct timings when the thread never ran on the
> monitored cpu. The time enabled was reported as a negative
> value.
