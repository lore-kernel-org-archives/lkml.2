Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1KPKJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:09:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57805 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1KPKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:09:40 -0500
MIME-Version: 1.0
In-Reply-To: <4EC264AA.30306@redhat.com>
References: <4EB3FA89.6090601@redhat.com>
	<4EC264AA.30306@redhat.com>
Date: Wed, 16 Nov 2011 15:39:39 +0530
Message-ID: <CAKTCnzkczaSo==AJREX1LtbBeeybn3fsKS84ibbgc_FEMbedFg@mail.gmail.com>
Subject: Re: [RFC PATCH V2] Enforce RSS+Swap rlimit
From: Balbir Singh <bsingharora@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 6:40 PM, Jerome Marchand <jmarchan@redhat.com> wrote:
>
> Change since V1: rebase on 3.2-rc1
>
> Currently RSS rlimit is not enforced. We can not forbid a process to exceeds
> its RSS limit and allow it swap out. That would hurts the performance of all
> system, even when memory resources are plentiful.
>
> Therefore, instead of enforcing a limit on rss usage alone, this patch enforces
> a limit on rss+swap value. This is similar to memsw limits of cgroup.
> If a process rss+swap usage exceeds RLIMIT_RSS max limit, he received a SIGBUS
> signal.
>
> My tests show that code in do_anonymous_page() and __do_fault() indeed prevents
> processes to get more memory than the limit and I haven't seen any adverse
> effect, but so far, I have no test coverage of the code in do_wp_page(). I'm
> not sure how to test it.
>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

I think we need the get_mm_rss* definitions need to be revisited and
agreed upon. I am afraid it cannot be simple addition, since

1. It does not account for shared pages
2. If we enforce a limit without accounting for sharing, we might
enforce wrong limits

Balbir
