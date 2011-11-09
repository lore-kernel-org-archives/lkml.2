Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1KIVBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:01:20 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:9185 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab1KIVBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:01:18 -0500
Date: Wed, 9 Nov 2011 13:01:18 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: LKML <linux-kernel@vger.kernel.org>
Message-ID: <820243891.352129.1320872478210.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <51331881.351549.1320871450391.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Subject: /dev/mem "unbounded?"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.61.162]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - FF3.0 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear LKML,

In the previous kernels, valid_phys_addr_range was not
defined for x86, and used the static variant which
returned 0 if access went above __pa(high_memory).

Current behavior, though, relies on the x86 variant
of valid_phys_addr_range, defined in arch/x86/include/asm/io.h,
that always returns 1, hence, reading will never end since there
won't be any condition (barring an MCE on physical hardware) that
would say "Bad Address". Is this supposed to be by design?

How about exposing the "top" allocated resource address from 
linux/kernel/resource.c? That way /dev/mem will know when
all the "interesting" bits end, and can return -EFAULT for
everything above that.

Thanks,
A

