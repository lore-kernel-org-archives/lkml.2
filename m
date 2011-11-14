Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1KNVVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:21:41 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:30768 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237Ab1KNVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:21:40 -0500
Date: Mon, 14 Nov 2011 13:21:40 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <2018804336.46235.1321305700330.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1320881479-16711-1-git-send-email-andreiw@vmware.com>
Subject: Re: [PATCH] /dev/mem: Fix wrong error on accessing beyond valid
 memory addresses.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

----- Original Message -----
> From: "Andrei Warkentin" <andreiw@vmware.com>
> To: linux-kernel@vger.kernel.org
> Cc: "Andrei Warkentin" <andreiw@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>
> Sent: Wednesday, November 9, 2011 6:31:19 PM
> Subject: [PATCH] /dev/mem: Fix wrong error on accessing beyond valid memory addresses.
> 
> Currently this returns -EFAULT, but it really should be returning 0,
> as in - 0 bytes read or written. This is what you would get by
> opening a block device, seeking to the end, and trying to read
> something. Additionally, make lseek() check the sought-to offset
> to pass the valid_phys_addr_range test.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> ---

I know you're very busy, but I was wondering if you could
give your two cents on this change. This change grew from
our discussion on LKML last week.

Thanks ahead,
A
