Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab2FHHXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:23:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35954 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2FHHXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:23:42 -0400
Message-ID: <4FD1A872.7070906@vflare.org>
Date: Fri, 08 Jun 2012 00:23:30 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH] zram: fix random data read
References: <1339137567-29656-1-git-send-email-minchan@kernel.org> <1339137567-29656-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1339137567-29656-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 11:39 PM, Minchan Kim wrote:

> fd1a30de makes a bug that it uses (struct page *) as zsmalloc's handle
> although it's a uncompressed page so that it can access random page,
> return random data or even crashed by get_first_page in zs_map_object.
> 
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Cc: Jerome Marchand <jmarchan@redhat.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/zram_drv.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 


Great catch! The problem goes away after your next patch for using
zsmalloc for all the cases, still this fix can never hurt.

Acked-by: Nitin Gupta <ngupta@vflare.org>


Thanks,
Nitin
