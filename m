Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0JZJLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:11:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:58945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0JZJLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:11:20 -0400
Message-ID: <4CC69B22.2050708@kernel.org>
Date: Tue, 26 Oct 2010 11:10:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] MN10300: Fix the PERCPU() alignment to allow for workqueues
References: <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 09:11:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/26/2010 12:41 AM, David Howells wrote:
> PERCPU() alignment on MN13000, however, is only 32 bytes as set in
> vmlinux.lds.S.  So we set this to PAGE_SIZE (4096) to match most other arches
> and stick a comment in alloc_cwqs() for anyone else who triggers the assertion.

Ah, okay, but I'm not quite sure how that would affect the alignment
of dynamically allocated percpu memory.  Is this SMP or UP build?  Can
you please double check the bug doesn't trigger with the section
alignment updated?

> -  PERCPU(32)
> +  PERCPU(PAGE_SIZE)

Hmmm... during initialization, the initial percpu memory is
re-allocated using bootmem allocator with proper alignment and the
output section is just used as data source and discarded once init is
complete.  So, unless I'm mistaken, I don't think this would affect
anything.  That said, I think it might be better to just remove the
alignment parameter from the macro and force align to PAGE_SIZE.  It
doesn't really help anything.

Thanks.

-- 
tejun
