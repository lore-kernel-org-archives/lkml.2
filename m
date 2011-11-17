Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1KQXWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:22:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56745 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1KQXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:22:06 -0500
Date: Thu, 17 Nov 2011 15:22:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 0/2] Dummy HPAGE_* constants for
 !CONFIG_HUGETLB_PAGE
In-Reply-To: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> After a, somewhat heated, discussion with David Rientjes, I think the
> following approach will work.
> 
> The first patch adds HPAGE_SHIFT, needed by MIPS.
> 
> The second cleans up the exiting HPAGE_MASK and HPAGE_SIZE
> 
> David Daney (2):
>   hugetlb: Provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
>   hugetlb: Provide safer dummy values for HPAGE_MASK and HPAGE_SIZE
> 
>  include/linux/hugetlb.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> Cc: David Rientjes <rientjes@google.com>

Nack on both, we already discussed this in the other thread (and I 
wouldn't call it "somewhat heated").

We don't need these dummy definitions at all for any current architectures 
that use them and they should be removed so that any future code using 
them will have the proper dependency on CONFIG_HUGETLB_PAGE.
