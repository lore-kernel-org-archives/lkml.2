Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1KNWLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:11:15 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43448 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755148Ab1KNWLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:11:14 -0500
Date: Mon, 14 Nov 2011 14:11:13 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <1145760360.50519.1321308673807.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4EC18F5E.2040407@zytor.com>
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
> From: "H. Peter Anvin" <hpa@zytor.com>
> To: "Andrei Warkentin" <awarkentin@vmware.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Monday, November 14, 2011 4:59:58 PM
> Subject: Re: [PATCH] /dev/mem: Fix wrong error on accessing beyond valid memory addresses.
> 
> On 11/14/2011 01:21 PM, Andrei Warkentin wrote:
> >
> > I know you're very busy, but I was wondering if you could
> > give your two cents on this change. This change grew from
> > our discussion on LKML last week.
> >
> > Thanks ahead,
> > A
> 
> EOF seems wrong to me (not as bad as EFAULT, but still wrong).

Although that was what we had discussed, I do not return -EOF in the patch. As you
mention - that would be wrong. I played around with other devices (block, actually),
and if you attempt to read(2) beyond the end, read(2) simply returns 0, as in
zero bytes read out. Of course, lseek(2) beyond the end should return -EINVAL, as
well, so that is what that patch I CCd you on accomplishes.

A
