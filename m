Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2CTVR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:17:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab2CTVR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:17:26 -0400
Date: Tue, 20 Mar 2012 22:17:24 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] autonuma: release page_table_lock in scanning pmd
Message-ID: <20120320211723.GG24602@redhat.com>
References: <CAJd=RBAjXi04AwyCS94xFZkKNWv3ngKw=04Jw+Y9nNnMXjH-WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAjXi04AwyCS94xFZkKNWv3ngKw=04Jw+Y9nNnMXjH-WQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 08:30:48PM +0800, Hillf Danton wrote:
> Only for unlikely corner case, unlock is added to pair lock.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/autonuma.c	Sat Mar 17 11:01:50 2012
> +++ b/mm/autonuma.c	Tue Mar 20 19:58:44 2012
> @@ -522,7 +522,8 @@ static int knumad_scan_pmd(struct mm_str
>  				spin_unlock(&mm->page_table_lock);
>  				goto out;
>  			}
> -		}
> +		} else
> +			spin_unlock(&mm->page_table_lock);
>  	}
> 
>  	VM_BUG_ON(!pmd_present(*pmd));

I'm impressed by how fast you found these bugs.

Thanks a lot, applied!
Andrea
