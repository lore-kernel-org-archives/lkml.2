Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2I1Hs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:48:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34766 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2I1Hsz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 28 Sep 2012 03:48:55 -0400
Message-Id: <5065729C020000780009E63B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 28 Sep 2012 08:49:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <andrew.cooper3@citrix.com>, "xen-devel" <xen-devel@lists.xen.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] kexec: introduce kexec_ops struct
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Some kexec/kdump implementations (e.g. Xen PVOPS) on different archs could
> not use default functions or require some changes in behavior of kexec/kdump
> generic code. To cope with that problem kexec_ops struct was introduced.
> It allows a developer to replace all or some functions and control some
> functionality of kexec/kdump generic code.

I'm not convinced that doing this at the architecture independent
layer is really necessary/desirable. Nevertheless, if that's the right
place, then everything else looks good to me, except for a
cosmetic thing:

> @@ -392,7 +435,7 @@ static void kimage_free_page_list(struct list_head *list)
>  
>  		page = list_entry(pos, struct page, lru);
>  		list_del(&page->lru);
> -		kimage_free_pages(page);
> +		(*kexec_ops.kimage_free_pages)(page);

These constructs are generally better readable without the
explicit yet redundant indirection:

		kexec_ops.kimage_free_pages(page);

Jan


