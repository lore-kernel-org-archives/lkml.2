Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2LNOlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 09:41:06 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56311 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2LNOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 09:41:03 -0500
Message-ID: <50CB3A7A.9040400@pobox.com>
Date: Fri, 14 Dec 2012 09:40:58 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: Xiaotian Feng <dannyfeng@tencent.com>, Jeff Garzik <jgarzik@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>, stable@kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [libata] scsi: fix Null pointer dereference on disk error
References: <1355386339-11411-1-git-send-email-xtfeng@gmail.com>
In-Reply-To: <1355386339-11411-1-git-send-email-xtfeng@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 03:12 AM, Xiaotian Feng wrote:
> Following oops were observed when disk error happened:
>
> [ 4272.896937] sd 0:0:0:0: [sda] Unhandled error code
> [ 4272.896939] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 4272.896942] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 5a de a7 00 00 08 00
> [ 4272.896951] end_request: I/O error, dev sda, sector 5955239
> [ 4291.574947] BUG: unable to handle kernel NULL pointer dereference at (null)
> [ 4291.658305] IP: [] ahci_activity_show+0x1/0x40
> [ 4291.730090] PGD 76dbbc067 PUD 6c4fba067 PMD 0
> [ 4291.783408] Oops: 0000 [#1] SMP
> [ 4291.822100] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/sw_activity
> [ 4291.934235] CPU 9
> [ 4291.958301] Pid: 27942, comm: hwinfo ......
>
> ata_scsi_find_dev could return NULL, so ata_scsi_activity_{show,store} should check if atadev is NULL.
>
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: stable@kernel.org
> Cc: linux-ide@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/ata/libata-scsi.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

applied



