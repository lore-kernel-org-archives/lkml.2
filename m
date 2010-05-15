Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0EOTWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 15:22:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49384 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0EOTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 15:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VVUpxrKe9lU9Z9f7mqB+u/Uu1bLuF+XMbGzWuz7Nhrhk/yFembLPq0kpMm6tfDm4LC
         RJe3moUEbiFnHs5yuZzXDp/uwxv+XbkOllUM49AryM2/Uze9hBp5yzNxEWiM3yqFPnuD
         970NKQj2PNp71WQ/3DtI/HRRBdDnacGy217+8=
Message-ID: <4BEEF475.5000501@garzik.org>
Date: Sat, 15 May 2010 15:22:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net,
       bzolnier@gmail.com
Subject: Re: [PATCH 8/8] libata: implement on-demand HPA unlocking
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <1273946974-29131-9-git-send-email-tj@kernel.org>
In-Reply-To: <1273946974-29131-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2010 02:09 PM, Tejun Heo wrote:
> Implement ata_scsi_unlock_native_capacity() which will be called
> through SCSI layer when block layer notices that partitions on a
> device extend beyond the end of the device.  It requests EH to unlock
> HPA, waits for completion and returns the current device capacity.
>
> This allows libata to unlock HPA on demand instead of having to decide
> whether to unlock upfront.  Unlocking on demand is safer than
> unlocking by upfront because some BIOSes write private data to the
> area beyond HPA limit.  This was suggested by Ben Hutchings.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Suggested-by: Ben Hutchings<ben@decadent.org.uk>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


