Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2IFXLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:11:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2IFXLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:11:37 -0400
Date: Thu, 6 Sep 2012 16:11:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, cpw@sgi.com,
        steiner@sgi.com, jeremy.fitzhardinge@citrix.com,
        linux-kernel@vger.kernel.org, jbeulich@suse.com
Subject: Re: [PATCH] UV: fix incorrect tlb flush all issue
Message-Id: <20120906161136.b15e3d91.akpm@linux-foundation.org>
In-Reply-To: <1345798655-3669-1-git-send-email-alex.shi@intel.com>
References: <1345798655-3669-1-git-send-email-alex.shi@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012 16:57:35 +0800
Alex Shi <alex.shi@intel.com> wrote:

> The flush tlb optimization code has logical issue on UV platform.
> It doesn't flush the full range at all, since it simply
> ignores its 'end' parameter (and hence also the "all" indicator)
> in uv_flush_tlb_others() function.
> 
> This patch fixed this issue, but untested due to hardware leaking.

Well, it doesn't really come very close to being compilable:

arch/x86/platform/uv/tlb_uv.c: In function 'bau_process_message':
arch/x86/platform/uv/tlb_uv.c:283: error: 'struct bau_pq_entry' has no member named 'end'
arch/x86/platform/uv/tlb_uv.c:284: error: 'struct bau_pq_entry' has no member named 'start'

Cliff, could you please help out here?

