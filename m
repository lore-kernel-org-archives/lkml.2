Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2GBQ4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:56:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2GBQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:56:39 -0400
Date: Mon, 2 Jul 2012 09:56:33 -0700
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
Message-ID: <20120702165633.GA555@google.com>
References: <4FF06701.6010004@zytor.com>
 <4FF06DF4.4000006@zytor.com>
 <87wr2nsbvi.fsf@xmission.com>
 <4FF0769F.8090105@zytor.com>
 <87sjdbsb0v.fsf@xmission.com>
 <4FF07E66.2020706@zytor.com>
 <87d34fs914.fsf@xmission.com>
 <4FF085B1.6070604@zytor.com>
 <87a9zj9w43.fsf@xmission.com>
 <4FF098E2.3040307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF098E2.3040307@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Sun, Jul 01, 2012 at 11:37:22AM -0700, H. Peter Anvin wrote:
> If we don't need it, I think we can use -z max-page-size=4096, but we
> use the PMD alignment for percpu on x86-64; Tejun, does that apply to
> the .data..percpu section in the executable as well?

I don't think the .data..percpu section needs 2M alignment.  The
percpu data section is only used as init template and actual percpu
addresses always go through offsetting against __per_cpu_offset[] - no
matter what the vaddrs in the vmlinux are, they get offsetted into 2M
aligned linear address if necessary.  I think the only alignment
.data..percpu needs is cacheline alignment for separating its
subsections.

Thanks.

-- 
tejun
