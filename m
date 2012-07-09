Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GIWlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:41:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2GIWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:41:01 -0400
Date: Mon, 9 Jul 2012 15:41:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when
 order 0
Message-Id: <20120709154100.6a7377e6.akpm@linux-foundation.org>
In-Reply-To: <CAAmzW4P=Qf1u6spPZCN7o3TRqvwF-rZkZA3eFtAcnCdFg2CDBg@mail.gmail.com>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com>
	<CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
	<alpine.DEB.2.00.1207081547140.18461@chino.kir.corp.google.com>
	<CAAmzW4P=Qf1u6spPZCN7o3TRqvwF-rZkZA3eFtAcnCdFg2CDBg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012 23:13:50 +0900
JoonSoo Kim <js1304@gmail.com> wrote:

> >> In my kernel image, __alloc_pages_direct_compact() is not inlined by gcc.

My gcc-4.4.4 doesn't inline it either.

> I think __alloc_pages_direct_compact() can't be inlined by gcc,
> because it is so big and is invoked two times in __alloc_pages_nodemask().

This.  Large function, two callsites.

Making __alloc_pages_direct_compact() __always_inline adds only 26
bytes to my page_alloc.o's .text.  Such is the suckiness of passing
eleven arguments!

