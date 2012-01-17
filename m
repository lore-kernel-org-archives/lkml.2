Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2AQQxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:53:33 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47005 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab2AQQxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:53:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120115222932.GA24330@mobil.systemanalysen.net>
References: <20120115222932.GA24330@mobil.systemanalysen.net>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 17 Jan 2012 16:53:10 +0000
X-Google-Sender-Auth: 5MgyGhLfq3Rk79VMxA4DYKV28GA
Message-ID: <CAHkRjk7MGGJE04dgETmqs_SBb8ju2BOiEmei3aV8MRcpof8-GA@mail.gmail.com>
Subject: Re: [kmemleak report 0/2] kernel 3.1.6, x86_64
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2012 22:29, Roland Eggner <edvx1@systemanalysen.net> wrote:
> It looks like memory leaks are “eating” 1G+ after only 1 week uptime … that's
> not nice.

Does your system actually lose this memory or they are just be false
positives? We've known since around 3.1 that kmemleak has some issues
with per-cpu memory allocations and reporting false positives. The
patches just went in (to be visible in 3.3-rc1). Alternatively, you
could cherry-pick them from here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=shortlog;h=029aeff5db879afd7760f11214b6fea45f76b58e

(commit f528f0b8e5 "kmemleak: Handle percpu memory allocation" is the
one you would need)

Thanks.

-- 
Catalin
