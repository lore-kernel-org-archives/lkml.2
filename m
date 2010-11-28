Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0K1WjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:39:23 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27739 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0K1WjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:39:22 -0500
Date: Sun, 28 Nov 2010 23:31:57 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        mjg@redhat.com, carlos@strangeworlds.co.uk, stable@kernel.org,
        ceolin@ulevel.com
Subject: Re: [PATCH] wmi: use memcmp instead of strncmp to compare GUIDs
In-Reply-To: <1290980810-5903-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1011282331330.29621@swampdragon.chaosbits.net>
References: <1290980810-5903-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Nov 2010, Thadeu Lima de Souza Cascardo wrote:

> While looking for the duplicates in /sys/class/wmi/, I couldn't find
> them. The code that looks for duplicates uses strncmp in a binary GUID,
> which may contain zero bytes. The right function is memcmp, which is
> also used in another section of wmi code.
> 
> It was finding 49142400-C6A3-40FA-BADB-8A2652834100 as a duplicate of
> 39142400-C6A3-40FA-BADB-8A2652834100. Since the first byte is the fourth
> printed, they were found as equal by strncmp.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/platform/x86/wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
> index 104b77c..aecd9a9 100644
> --- a/drivers/platform/x86/wmi.c
> +++ b/drivers/platform/x86/wmi.c
> @@ -755,7 +755,7 @@ static bool guid_already_parsed(const char *guid_string)
>  	struct wmi_block *wblock;
>  
>  	list_for_each_entry(wblock, &wmi_block_list, list)
> -		if (strncmp(wblock->gblock.guid, guid_string, 16) == 0)
> +		if (memcmp(wblock->gblock.guid, guid_string, 16) == 0)
>  			return true;
>  
>  	return false;
> 

Looks right to me.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

