Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2IIUjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:39:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48366 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab2IIUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:39:09 -0400
Message-ID: <504CFE6A.6020403@pobox.com>
Date: Sun, 09 Sep 2012 16:39:06 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arvydas Sidorenko <asido4@gmail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Jeff Garzik <jeff@garzik.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com> <20120703090441.GA4804@gmail.com> <4FF351F8.1000003@msgid.tls.msk.ru> <20120704024715.GA17095@gmail.com> <4FF3E478.50609@msgid.tls.msk.ru> <20120704070604.GA17769@gmail.com> <CA+6av4mdQ3daHHakRDCmHR_zMfcA_cAoabSuwBrcfjpYgUcXyg@mail.gmail.com>
In-Reply-To: <CA+6av4mdQ3daHHakRDCmHR_zMfcA_cAoabSuwBrcfjpYgUcXyg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 04:34 PM, Arvydas Sidorenko wrote:
>> Meanwhile there already has a number of SATA disks that have supported
>> this feature.  So I think maybe we can enable it.
>>
>> Regards,
>> Zheng
>
> Blindly enabling FUA by default in my opinion is not a good idea at all.
> I believe the focus should be on detecting FUA support on the device
> instead, which the kernel at this point cannot reliably do (is it possible?).

Premature assumptions.  It is entirely possible that FUA is detected 
accurately, but the software is missing a flush somewhere that FUA 
requires, if disks are to be used in FUA mode.

The filesystem and the block layer must properly generate and order 
their I/Os based on the FUA enablement bits that appear in the block 
layer after libata discovers the SATA FUA feature.

	Jeff




