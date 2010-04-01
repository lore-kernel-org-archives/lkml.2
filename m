Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0DAAjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:39:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34755 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab0DAAjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:39:07 -0400
Message-ID: <4BB3EA55.50505@zytor.com>
Date: Wed, 31 Mar 2010 17:35:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org> <4BB3DC23.50005@zytor.com> <4BB3E0CA.5060405@kernel.org>
In-Reply-To: <4BB3E0CA.5060405@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 04:54 PM, Yinghai Lu wrote:
> 
> ---
>  mm/bootmem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/bootmem.c
> ===================================================================
> --- linux-2.6.orig/mm/bootmem.c
> +++ linux-2.6/mm/bootmem.c
> @@ -303,7 +303,7 @@ unsigned long __init free_all_bootmem_no
>  unsigned long __init free_all_bootmem(void)
>  {
>  #ifdef CONFIG_NO_BOOTMEM
> -	return free_all_memory_core_early(NODE_DATA(0)->node_id);
> +	return free_all_memory_core_early(MAX_NUMNODES);
>  #else
>  	return free_all_bootmem_core(NODE_DATA(0)->bdata);
>  #endif
> 
>>
>> Furthermore, I really don't see the connection between this and James
>> Morris' reported problem, which he reports as "amd64", which presumably
>> is an x86-64 kernel and not 32 bits...  James, is that correct?  Any
>> more details you can give about the system?  I *really* don't want to go
>> into cargo cult programming mode, that would suck eggs no matter what.
> 
> it happened one of my test setup, node0 ram disappear somehow.
> and i found the 32bit numa doesn't work on that.
> 

... which is useful and valid, but I still think this isn't related to
James' problem, if James' problem wasn't actually fixed in -rc3.  That's
the part that I'm afraid I have to be confused about... all the known
problems except the above are fixed in -rc3, and I'd at least like to
have a validated bug report of any sort before saying it should all be
tossed.

This patch looks a lot better.  The whole use of MAX_NUMNODES as a
sentinel (which appears inherited from mm/page_alloc.c, and as such is a
pre-existing convention which is also invoked here) really could use a
comment, though.

	-hpa
