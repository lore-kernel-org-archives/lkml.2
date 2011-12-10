Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1LJUCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 15:02:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:43066 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1LJUCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 15:02:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="85800861"
From: Andi Kleen <andi@firstfloor.org>
To: t cheney <cdmalord@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add process memory layout to coredump file
References: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
Date: Sat, 10 Dec 2011 12:02:39 -0800
In-Reply-To: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
	(t. cheney's message of "Sat, 10 Dec 2011 22:37:02 +0800")
Message-ID: <m2y5uknqjk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

t cheney <cdmalord@gmail.com> writes:

> This patch just add memory layout(same as /proc/pid/maps) to
> coredump file. The layout is appended to corenote segment with
> flag NT_MAPS=7.

Seems like a reasonable idea, but can you please share code with 
the proc implementation? 

It's a bit unusal to have ASCII in a coredump, but I suppose expressing
this in binary would be somewhat ugly.

> +	char *buf = notes->data;
> +	size_t core_limit = notes->datasz;
> +	gate_vma = get_gate_vma(current->mm);
> +

It seems a bit dubious to do this without locking even in a core dump.

> +	for (vma = first_vma(current, gate_vma); vma != NULL;
> +		vma = next_vma(vma, gate_vma)) {
> +		flags = vma->vm_flags;
> +		maps_size += len;
> +		if (file) {
> +			if (maps_size > core_limit)
> +				break;

You have a one-off bug here. Also below.

> +			DUMP_WRITE(buf, len, foffset);
> +		}


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
