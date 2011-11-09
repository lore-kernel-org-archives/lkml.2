Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab1KIWis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:38:48 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:39970 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271Ab1KIWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:38:47 -0500
Date: Wed, 9 Nov 2011 14:38:46 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1927751307.356328.1320878326756.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4EBAFC33.5080605@zytor.com>
Subject: Re: /dev/mem "unbounded?"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.61.162]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - FF3.0 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

----- Original Message -----
> 
> That would be incorrect behavior, though, except perhaps for the
> range
> that cannot be addressed by the processor.  It is explicitly
> permitted
> to address ranges that does not have addresses mapped to it.

There is a current mechanism for restricting access to a subset
of addresses, and it is used to enforce < 1MB accesses on x86
if CONFIG_STRICT_DEVMEM. This could be extended.

Do you think there is any value in specifying something like
CONFIG_DEV_MEM_ONLY_CLAIMED, which would only allow accesses
until the end of the last range claimed with request_region (but
could, of course, well be unmapped). This will allow accesses to
any unclaimed "holes" in between. I.e., if you have 0-100m claimed,
followed by 300-700m claimed, then reading /dev/mem will work up
until you reach 700m.

> 
> -EFAULT would also be wrong.  If anything it should be -EIO.
> 

Ok, I'll submit a patch for that.

A
