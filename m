Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab0EPFqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 01:46:34 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:36230 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0EPFqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 01:46:32 -0400
Date: Sun, 16 May 2010 08:45:57 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] list debugging: warn when deleting a deleted entry
Message-ID: <20100516054557.GA9373@tarshish>
References: <5e659adf538ddcba285c1e8963f4438828c29902.1273047097.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e659adf538ddcba285c1e8963f4438828c29902.1273047097.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Ping?
Any comment on this?

baruch

On Wed, May 05, 2010 at 11:14:29AM +0300, Baruch Siach wrote:
> Use the magic LIST_POISON* values to detect an incorrect use of list_del on a
> deleted entry. This DEBUG_LIST specific warning is easier to understand than
> the generic Oops message caused by LIST_POISON dereference.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  lib/list_debug.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/list_debug.c b/lib/list_debug.c
> index 1a39f4e..344c710 100644
> --- a/lib/list_debug.c
> +++ b/lib/list_debug.c
> @@ -43,6 +43,12 @@ EXPORT_SYMBOL(__list_add);
>   */
>  void list_del(struct list_head *entry)
>  {
> +	WARN(entry->next == LIST_POISON1,
> +		"list_del corruption, next is LIST_POISON1 (%p)\n",
> +		LIST_POISON1);
> +	WARN(entry->next != LIST_POISON1 && entry->prev == LIST_POISON2,
> +		"list_del corruption, prev is LIST_POISON2 (%p)\n",
> +		LIST_POISON2);
>  	WARN(entry->prev->next != entry,
>  		"list_del corruption. prev->next should be %p, "
>  		"but was %p\n", entry, entry->prev->next);
> -- 
> 1.7.0
> 

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
