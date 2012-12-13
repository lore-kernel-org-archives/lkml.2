Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2LMEa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:30:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58120 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LMEa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:30:57 -0500
Message-ID: <50C959FD.7070408@vflare.org>
Date: Wed, 12 Dec 2012 20:30:53 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: zram: fix invalid memory references during disk write
References: <1354257909-2380-1-git-send-email-ngupta@vflare.org> <20121211182720.GC29421@kroah.com>
In-Reply-To: <20121211182720.GC29421@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 10:27 AM, Greg KH wrote:
> On Thu, Nov 29, 2012 at 10:45:09PM -0800, Nitin Gupta wrote:
>> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
>> of incompressible pages") which caused invalid memory references
>> during disk write. Invalid references could occur in two cases:
>>  - Incoming data expands on compression: In this case, reference was
>> made to kunmap()'ed bio page.
>>  - Partial (non PAGE_SIZE) write with incompressible data: In this
>> case, reference was made to a kfree()'ed buffer.
>>
>> Fixes bug 50081:
>> https://bugzilla.kernel.org/show_bug.cgi?id=50081
>>
>> Upstream commit ID: c8f2f0d: zram: Fix handling of incompressible pages
>> Apply to versions: 3.6.5, 3.6.6, 3.6.7, 3.6.8
>>
>> Cc: <stable@vger.kernel.org> # staging-next: 37b51fd: zram: factor-out
>> 				# zram_decompress_page() function
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
>> Reported-by: Tomas M <tomas@slax.org>
>> Reviewed-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/staging/zram/zram_drv.c |   39 ++++++++++++++++++++++++---------------
>>  1 file changed, 24 insertions(+), 15 deletions(-)
> 
> This patch fails to apply to 3.6.10:
> 
> patching file drivers/staging/zram/zram_drv.c
> Hunk #1 succeeded at 282 (offset 17 lines).
> Hunk #2 FAILED at 286.
> Hunk #3 succeeded at 319 (offset 17 lines).
> Hunk #4 succeeded at 340 (offset 17 lines).
> Hunk #5 succeeded at 353 (offset 17 lines).
> Hunk #6 succeeded at 368 (offset 17 lines).
> Hunk #7 succeeded at 385 (offset 17 lines).
> 1 out of 7 hunks FAILED -- saving rejects to file drivers/staging/zram/zram_drv.c.rej
> 
> Please redo this patch and resend it if you wish for it to be applied to
> the 3.6-stable tree.
>

Please apply 37b51fd ("zram: factor-out zram_decompress_page()
function") before applying this patch. I also mentioned this in the
changelog description above in the format as specified in
stable_kernel_rules.txt but looks like I misunderstood that doc.

Thanks,
Nitin


