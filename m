Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1KIWSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:18:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36170 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1KIWSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:18:33 -0500
Message-ID: <4EBAFC33.5080605@zytor.com>
Date: Wed, 09 Nov 2011 14:18:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrei Warkentin <awarkentin@vmware.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: /dev/mem "unbounded?"
References: <820243891.352129.1320872478210.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <820243891.352129.1320872478210.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 01:01 PM, Andrei Warkentin wrote:
> Dear LKML,
> 
> In the previous kernels, valid_phys_addr_range was not
> defined for x86, and used the static variant which
> returned 0 if access went above __pa(high_memory).
> 
> Current behavior, though, relies on the x86 variant
> of valid_phys_addr_range, defined in arch/x86/include/asm/io.h,
> that always returns 1, hence, reading will never end since there
> won't be any condition (barring an MCE on physical hardware) that
> would say "Bad Address". Is this supposed to be by design?
> 
> How about exposing the "top" allocated resource address from 
> linux/kernel/resource.c? That way /dev/mem will know when
> all the "interesting" bits end, and can return -EFAULT for
> everything above that.
> 

That would be incorrect behavior, though, except perhaps for the range
that cannot be addressed by the processor.  It is explicitly permitted
to address ranges that does not have addresses mapped to it.

-EFAULT would also be wrong.  If anything it should be -EIO.

	-hpa

