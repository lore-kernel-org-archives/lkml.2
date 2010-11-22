Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0KVVot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:44:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40787 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab0KVVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w1PGAfadKXrM0l1cWGismj5Znx2ROC9idPfZ7nOcwW/ppcZgGcjOFzKx2crCxz2Mse
         wwPPz0pjBwTmYNuj0Hv6vwtc3xM1uNI8/gxGvu+hAcm4dRppgiWSB/5dG8OttHmQJcWD
         YZpmVP0PaCKvO58R6U7WDNk5G+yhVCed7wLL8=
Message-ID: <4CEAE44C.1030004@gmail.com>
Date: Mon, 22 Nov 2010 13:44:44 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Jesper Juhl <jj@chaosbits.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: general protection fault: 0000 [#1] SMP
References: <AANLkTik=d4nOUAd_DZCsJL44NB5OvYmux+b58mqs1PGH@mail.gmail.com> <alpine.LNX.2.00.1011202322050.24071@swampdragon.chaosbits.net> <alpine.LNX.2.00.1011202331090.24071@swampdragon.chaosbits.net> <4CEABDFD.9080908@gmail.com> <alpine.LSU.2.00.1011221218350.15953@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1011221218350.15953@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2010 12:25 PM, Hugh Dickins wrote:
> On Mon, 22 Nov 2010, Justin P. Mattock wrote:
>
>> <---- cut -------->
>>
>> cleaned the thread up.. Anyways after doing some debugging with gdb and with
>> valgrind for an application that keeps segfaulting I noticed this in dmesg:
>>
>> [ 3028.571941] FIREWALL:INPUT IN=wlan0 OUT=
>> MAC=ff:ff:ff:ff:ff:ff:00:23:12:65:cb:02:08:00 SRC=0.0.0.0
>> DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=255 ID=57984 PROTO=UDP
>> SPT=68 DPT=67 LEN=308
>> [ 3061.177655] BUG: Bad page state in process make  pfn:2134c
>> [ 3061.177661] page:ffffea00007438a0 count:0 mapcount:0 mapping:   (null)
>> index:0x507
>> [ 3061.177663] page flags: 0x4000000000000008(uptodate)
>> [ 3061.177669] Pid: 5691, comm: make Not tainted 2.6.37-rc2-00039-g0211924
>> #7
>> [ 3061.177671] Call Trace:
>> [ 3061.177680]  [<ffffffff810c5900>] ? dump_page+0xc0/0xc5
>> [ 3061.177684]  [<ffffffff810c5f18>] bad_page+0xd8/0xea
>> [ 3061.177688]  [<ffffffff810c7aeb>] get_page_from_freelist+0x344/0x4a0
>> [ 3061.177693]  [<ffffffff811bf123>] ? inode_has_perm+0x68/0x6a
>> [ 3061.177697]  [<ffffffff810c7d6b>] __alloc_pages_nodemask+0x124/0x645
>> [ 3061.177701]  [<ffffffff810f7cf2>] ? __dentry_open+0x194/0x2a1
>> [ 3061.177705]  [<ffffffff810dc155>] handle_mm_fault+0x2a8/0x82f
>> [ 3061.177710]  [<ffffffff811056ec>] ? do_filp_open+0x1f3/0x646
>> [ 3061.177714]  [<ffffffff810f4226>] ? check_object+0x13b/0x1eb
>> [ 3061.177719]  [<ffffffff81447d8e>] do_page_fault+0x3ec/0x411
>> [ 3061.177722]  [<ffffffff810f4b95>] ? free_debug_processing+0x1c5/0x208
>> [ 3061.177726]  [<ffffffff81103958>] ? getname+0x2c/0x1be
>> [ 3061.177728]  [<ffffffff810f4d08>] ? __slab_free+0x130/0x145
>> [ 3061.177732]  [<ffffffff81444e25>] page_fault+0x25/0x30
>> [ 3061.177734] Disabling lock debugging due to kernel taint
>> [ 3126.418774] type=1400 audit(1290451825.417:178): avc:  denied
>>
>> from what I remember using valgirnd with the app took a while to load but am
>> unsure if is the reason for the above message.
>
> This particular error is almost certainly fixed by rc3's patch below.
> Whether your earlier errors are a side-effect of the same Uptodate bug
> I cannot say: it's conceivable, but I don't see it as likely.  Maybe
> you should just move up to rc3 and see what happens with that.
>
> Hugh
>
> From: Markus Trippelsdorf<markus@trippelsdorf.de>
> Date: Thu, 18 Nov 2010 02:46:06 +0000 (-0500)
> Subject: ext4: fix setting random pages PageUptodate
> X-Git-Tag: v2.6.37-rc3~1^2~5
> X-Git-Url: http://127.0.0.1:1234/?p=.git;a=commitdiff_plain;h=08da1193d2c8c7a25d0cef7f85d0b9f1ad7c583a
>
> ext4: fix setting random pages PageUptodate
>
> ext4_end_bio calls put_page and kmem_cache_free before calling
> SetPageUpdate(). This can result in setting the PageUptodate bit on
> random pages and causes the following BUG:
>
>   BUG: Bad page state in process rm  pfn:52e54
>   page:ffffea0001222260 count:0 mapcount:0 mapping:          (null) index:0x0
>   arch kernel: page flags: 0x4000000000000008(uptodate)
>
> Fix the problem by moving put_io_page() after the SetPageUpdate() call.
>
> Thanks to Hugh Dickins for analyzing this problem.
>
> Reported-by: Markus Trippelsdorf<markus@trippelsdorf.de>
> Tested-by: Markus Trippelsdorf<markus@trippelsdorf.de>
> Signed-off-by: Markus Trippelsdorf<markus@trippelsdorf.de>
> Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> ---
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 7f5451c..beacce1 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -237,8 +237,6 @@ static void ext4_end_bio(struct bio *bio, int error)
>   			} while (bh != head);
>   		}
>
> -		put_io_page(io_end->pages[i]);
> -
>   		/*
>   		 * If this is a partial write which happened to make
>   		 * all buffers uptodate then we can optimize away a
> @@ -248,6 +246,8 @@ static void ext4_end_bio(struct bio *bio, int error)
>   		 */
>   		if (!partial_write)
>   			SetPageUptodate(page);
> +
> +		put_io_page(io_end->pages[i]);
>   	}
>   	io_end->num_io_pages = 0;
>   	inode = io_end->inode;
>


alright.. will do..

Justin P. Mattock
