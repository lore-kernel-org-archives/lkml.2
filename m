Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1FJQrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:47:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33278 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab1FJQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:47:21 -0400
Message-ID: <4DF24A76.50703@vflare.org>
Date: Fri, 10 Jun 2011 09:46:46 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 4/4] Staging: zram: Replace mutex lock by a R/W semaphore
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com> <1307712529-9757-2-git-send-email-jmarchan@redhat.com> <1307712529-9757-3-git-send-email-jmarchan@redhat.com> <1307712529-9757-4-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1307712529-9757-4-git-send-email-jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 06:28 AM, Jerome Marchand wrote:
> Currently, nothing protects zram table from concurrent access.
> For instance, ZRAM_UNCOMPRESSED bit can be cleared by zram_free_page()
> called from a concurrent write between the time ZRAM_UNCOMPRESSED has
> been set and the time it is tested to unmap KM_USER0 in
> zram_bvec_write(). This ultimately leads to kernel panic.
>
> Also, a read request can occurs when the page has been freed by a
> running write request and before it has been updated, leading to
> zero filled block being incorrectly read and "Read before write"
> error message.
>
> This patch replace the current mutex by a rw_semaphore. It extends
> the protection to zram table (currently, only compression buffers are
> protected) and read requests (currently, only write requests are
> protected).
>

These locking issues are probably remnants of earlier versions where
zram could be used only as a swap disks under which case it was not
possible for a read and write on the same sector (page) to happen
concurrently and thus there was no need to protect the table.


> Signed-off-by: Jerome Marchand<jmarchan@redhat.com>

Reviewed-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
