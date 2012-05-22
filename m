Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab2EVCTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:19:25 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:41281 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2EVCTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:19:24 -0400
Message-ID: <4FBAF76B.8060704@reinelt.co.at>
Date: Tue, 22 May 2012 04:18:19 +0200
From: Michael Reinelt <michael@reinelt.co.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.0.7) Gecko/20061013 Thunderbird/1.5.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: MTRR cleanup does not kick in
References: <4F6430F7.70207@reinelt.co.at>
In-Reply-To: <4F6430F7.70207@reinelt.co.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

may I draw your attention again to this issue?

I just run linux-3.4.0, seems to have still this problem (where I am not sure if this is a problem at all)

regards, Michael

Am 2012-03-17 07:36, schrieb Michael Reinelt:
> Hi there,
>
> I am (again) suffering from:
> kernel: mtrr: no more MTRRs available
> kernel: [drm] MTRR allocation failed.  Graphics performance may suffer.
>
> kernel is vanilla 3.2.11
>
> I know that this *used* to work, but I had to specify mtrr_gran_size=16M mtrr_chunk_size=128M on the kernel command line.
>
> Now, with the current kernel, I could not find *any* MTRR cleanup debug messages at all.
>
> I debugged a bit, and probably found the cause:
>
> arch/x86/kernel/cpu/mtrr/cleanup.c:mtrr_need_cleanup(void)
>
> /* Check if we only had WB and UC */
> if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
>     num_var_ranges - num[MTRR_NUM_TYPES])
>     return 0;
>
> This one kicks in, and disables the MTRR cleanup, resulting in all 10 MTRR registers in use, and no more MTRRs 
> available for DRM.
>
> I disabled this check, and now the MTRR cleaner works fine, even finding a optimal value for my system with only 9 
> registers, leaving one available for DRM.
>
>
> maybe the mtrr_need_cleanup() function should take nr_mtrr_spare_reg into account?
>
>
>
>
> regards, Michael
>
> PS please keep me on CC as I'm not subscribed. thanks!
>

-- 
Michael Reinelt<michael@reinelt.co.at>
http://home.pages.at/reinelt
GPG-Key 0xDF13BA50
ICQ #288386781

