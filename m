Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1C2WYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:24:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755161Ab1C2WYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:24:48 -0400
Date: Tue, 29 Mar 2011 15:24:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: add alignment for some variables
Message-Id: <20110329152434.d662706f.akpm@linux-foundation.org>
In-Reply-To: <1301360054.3981.31.camel@sli10-conroe>
References: <1301277536.3981.27.camel@sli10-conroe>
	<m2oc4v18x8.fsf@firstfloor.org>
	<1301360054.3981.31.camel@sli10-conroe>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 08:54:14 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> -struct percpu_counter vm_committed_as;
> +struct percpu_counter vm_committed_as ____cacheline_internodealigned_in_smp;

Why ____cacheline_internodealigned_in_smp?  That's pretty aggressive.

afacit the main benefit from this will occur if the read-only
vm_committed_as.counters lands in the same cacheline as some
write-frequently storage.

But that's a complete mad guess and I'd prefer not to have to guess.

