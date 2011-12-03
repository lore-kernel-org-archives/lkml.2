Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1LCVIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 16:08:07 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55417 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1LCVID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 16:08:03 -0500
Message-ID: <4EDA8FA9.8020004@linux.vnet.ibm.com>
Date: Sat, 03 Dec 2011 22:07:53 +0100
From: Steffen Maier <maier@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stratos Psomadakis <psomas@gentoo.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org, gregkh@suse.de,
        linux-scsi@vger.kernel.org, JBottomley@parallels.com, matthew@wil.cx,
        Martin.vGagern@gmx.net, kernel@gentoo.org
Subject: Re: [SCSI] NULL pointer dereference in sym53c8xx (bisected)
References: <4ED8EE1C.4090404@gentoo.org>
In-Reply-To: <4ED8EE1C.4090404@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
x-cbid: 11120321-1948-0000-0000-0000004B2049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 04:26 PM, Stratos Psomadakis wrote:
> After upstream commit 4e6c82b3614a18740ef63109d58743a359266daf ([SCSI]
> fix WARNING: at drivers/scsi/scsi_lib.c:1704), which is also included in
> 3.0-stable and 3.1-stable kernels, the kernel fails to boot (NULL
> pointer dereference in sym53c8xx_slave_destroy).
>
> Bug report at the Gentoo Bugzilla (reported and bisected by Martin von
> Gagern). [1]  (stack trace [2])
>
> I think that the problem is that (after commit 4e6c82b)
> __scsi_remove_device() is called if slave_alloc() in scsi_alloc_sdev()
> fails. But __scsi_remove_device() calls slave_destroy(), which (I think)
> doesn't make much sense (ie to call slave_destroy() when slave_alloc()
> fails).
>
> For sym53c8xx, this results in a NULL pointer dereference (struct
> sym_lcb pointer) in slave_destroy().
>
> [1] https://bugs.gentoo.org/show_bug.cgi?id=392567
> [2] https://392567.bugs.gentoo.org/attachment.cgi?id=294381

To me this looks like the same thing we encountered in the zfcp LLD:
http://www.spinics.net/lists/linux-scsi/msg55575.html
James explained the pairing of slave_alloc and slave_destroy even if 
slave_alloc returned early in which case slave_destroy needs to cope 
with that:
http://www.spinics.net/lists/linux-scsi/msg55449.html

HTH
Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

