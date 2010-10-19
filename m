Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab0JSCSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:18:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724Ab0JSCR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:17:59 -0400
Date: Mon, 18 Oct 2010 19:18:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] Add vzalloc shortcut
Message-Id: <20101018191840.89b39aa3.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=t2U5wa_7pqcb1pAq6p_x7VqYKbfMDZ10q+Geq@mail.gmail.com>
References: <20101016043331.GA3177@darkstar>
	<20101018164647.bc928c78.akpm@linux-foundation.org>
	<AANLkTikVueTjihngtC2rsoeqkUb5Wg-zeEFH1HKgcuuo@mail.gmail.com>
	<AANLkTi=t2U5wa_7pqcb1pAq6p_x7VqYKbfMDZ10q+Geq@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 09:55:17 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> On Tue, Oct 19, 2010 at 9:27 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On Tue, Oct 19, 2010 at 7:46 AM, Andrew Morton
> >>
> >> Also, a slightly better implementation would be
> >>
> >> static inline void * vmalloc_node_flags(unsigned long size, gfp_t flags)
> >> {
> >>        return  vmalloc_node(size, 1, flags, PAGE_KERNEL, -1,
> >>                                 builtin_return_address(0));
> >> }
> 
> Is this better? might  vmalloc_node_flags would be used by other than vmalloc?
> 
> static inline void * vmalloc_node_flags(unsigned long size, int node,
> gfp_t flags)

I have no strong opinions, really.  If we add more and more arguments
to vmalloc_node_flags() it ends up looking like vmalloc_node(), so we
may as well just call vmalloc_node().  Do whatever feels good ;)

