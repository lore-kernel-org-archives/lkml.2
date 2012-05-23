Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965281Ab2EWQCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:02:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:61828 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965054Ab2EWQCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:02:35 -0400
X-IronPort-AV: E=Sophos;i="4.75,645,1330923600"; 
   d="scan'208";a="25522098"
Message-ID: <4FBD0A19.30701@citrix.com>
Date: Wed, 23 May 2012 17:02:33 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <david.vrabel@citrix.com>,
        <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] fixes to stable/for-linus-3.5
References: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/12 22:42, Konrad Rzeszutek Wilk wrote:
> 
> The autoballoon one would try to balloon up to E820_MAX when
> there were no dom0_mem=.. argument.

I don't see this behaviour and looking at the code I don't see how it
could.  The autoballoon code only populates pages that were released so
it won't go above xen_start_info->nr_pages.

Do you have any logs showing the problem behaviour?

> The patch fixes it, and
> is also makes the dom0_mem=1G case work better (I think?). The
> other solution would be to use the current_reservation patch
> I posted a while back to work-around when no dom0_mem= argument
> is used.

David
