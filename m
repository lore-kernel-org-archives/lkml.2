Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0F1Wcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 18:32:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33102 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0F1Wcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 18:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RhK6FR4ICkq5H698DZURc/5FGSIYFkDE0xXb4LPIe6qmGnFpMHr5xtr8AClRGNu91j
         Rvn7lz3SL1jNQc1+Nsx/Vk4hETB86A6VI2QHSc41ARwVs+cPe5wtiq5a2oCbVv2DOJ1B
         OKeB67AmSrYp4ElA+klQzkJolEtwTfXlcy9bY=
Message-ID: <4C292308.4050906@pobox.com>
Date: Mon, 28 Jun 2010 18:32:40 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 33/35] libata: take advantage of cmwq and remove concurrency
 limitations
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-34-git-send-email-tj@kernel.org>
In-Reply-To: <1277759063-24607-34-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 05:04 PM, Tejun Heo wrote:
> libata has two concurrency related limitations.
>
> a. ata_wq which is used for polling PIO has single thread per CPU.  If
>     there are multiple devices doing polling PIO on the same CPU, they
>     can't be executed simultaneously.
>
> b. ata_aux_wq which is used for SCSI probing has single thread.  In
>     cases where SCSI probing is stalled for extended period of time
>     which is possible for ATAPI devices, this will stall all probing.
>
> #a is solved by increasing maximum concurrency of ata_wq.  Please note
> that polling PIO might be used under allocation path and thus needs to
> be served by a separate wq with a rescuer.
>
> #b is solved by using the default wq instead and achieving exclusion
> via per-port mutex.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Jeff Garzik<jgarzik@pobox.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


