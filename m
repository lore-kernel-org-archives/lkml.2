Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2KGHqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:46:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59071 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2KGHqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:46:34 -0500
X-AuditID: 9c93016f-b7c7bae000000eb7-21-509a11d724fd
From: Namhyung Kim <namhyung@kernel.org>
To: linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, hyc.lee@gmail.com
Subject: Re: [PATCH] [perf] convert_variable_type does not correctly check type of arrays
References: <20121105224916.GA15530@order.stressinduktion.org>
Date: Wed, 07 Nov 2012 16:46:30 +0900
In-Reply-To: <20121105224916.GA15530@order.stressinduktion.org> (Hannes
	Frederic Sowa's message of "Mon, 5 Nov 2012 23:49:16 +0100")
Message-ID: <87bof9onxl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Mon, 5 Nov 2012 23:49:16 +0100, Hannes Frederic Sowa wrote:
> While casting an array of (unsigned) chars to a string, perf does not
> check the containing type but only the opaque type and is bailing out:
>
>   $ perf probe -v -a 'neigh_destroy:22 dev->name:string'
>   probe-definition(0): neigh_destroy:22 dev->name:string
>   symbol:neigh_destroy file:(null) line:22 offset:0 return:0 lazy:(null)
>   parsing arg: dev->name:string into type:string dev, name(1)
>   1 arguments
>   Use vmlinux: /home/hannes/linux/vmlinux
>   Using /home/hannes/linux/vmlinux for symbols
>   Probe point found: neigh_destroy+115
>   Searching 'dev' variable in context.
>   Converting variable dev into trace event.
>   converting name in dev
>   name type is (null).
>   Failed to cast into string: name is not (unsigned) char *.
>   Failed to find 'dev' in this function.
>   An error occurred in debuginfo analysis (-22).
>     Error: Failed to add events. (-22)
>
> After the code flow ensures that type could only be a pointer or
> array type, call die_get_real_type unconditionally again to fetch the
> containing type and have further validation been done on that Die.

Hyeoncheol posted a same fix before, but not merged yet, Arnaldo?

  https://lkml.org/lkml/2012/9/20/3

Thanks,
Namhyung

