Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab0F1JVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:21:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42437 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300Ab0F1JVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:21:34 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Grant Grundler <grundler@google.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Colin Tuckley <colin.tuckley@arm.com>
Subject: Re: [PATCH] sata_sil24: Use memory barriers before issuing commands
References: <20100610145706.15588.4562.stgit@e102109-lin.cambridge.arm.com>
	<AANLkTimdHs25zHe8DJUaOOo7wYW14Ds4c2ORaSBhRxSg@mail.gmail.com>
Date: Mon, 28 Jun 2010 10:21:19 +0100
In-Reply-To: <AANLkTimdHs25zHe8DJUaOOo7wYW14Ds4c2ORaSBhRxSg@mail.gmail.com>
	(Grant Grundler's message of "Fri, 25 Jun 2010 19:32:22 -0700")
Message-ID: <tnx39w77bsg.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jun 2010 09:21:23.0393 (UTC) FILETIME=[46D36310:01CB16A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Grant Grundler <grundler@google.com> wrote:
> On Thu, Jun 10, 2010 at 7:57 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>> The data in the cmd_block buffers may reach the main memory after the
>> writel() to the device ports.
>
> "ia-64 Linux Kernel" (mosberger and eranian) uses exactly this sequence
> as an example for wmb() on page 303.
>
> I'm curious about the system that exposed this problem. I believe wmb() fixes
>  an issue not exposed on most machines. Can any general comments be
> made about cache coherency, memory ordering (weak?), instruction ordering
>  (super scalar?), etc. ?
>
> The explanation above is a bit short (most people won't understand it).

I already posted a second version of this patch, though it triggered a
longer discussion on whether we should do this (cross-post between LKML,
linux-ide and linux-arch):

http://thread.gmane.org/gmane.linux.ide/46414

I know IA-64 and a several other architectures have weak memory ordering
but some of them just add barriers in the I/O accessors (with some
performance penalty).

Since the (new) patch is already in mainline, please comment on the other
thread for memory ordering etc.

Thanks.

-- 
Catalin
