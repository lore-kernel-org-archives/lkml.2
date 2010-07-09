Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0GIPGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:06:22 -0400
Received: from claw.goop.org ([74.207.240.146]:60891 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0GIPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:06:21 -0400
Message-ID: <4C373AEC.6000502@goop.org>
Date: Fri, 09 Jul 2010 08:06:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: mmu notifier calls in apply_to_page_range()
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed that the original mmu notifier change (cddb8a5c14a) adds
calls to mmu_notifier_invalidate_range_start/end to
apply_to_page_range().  This doesn't seem correct to me, since
apply_to_page_range can perform arbitrary operations to the range of
pages, not just invalidation of the pages.  It seems to me that the
appropriate mmu notifiers should be called either around the call to
apply_to_page_range(), or from within the callback function.

Andrea, what's the rationale for mmu_notifier_invalidate_range_start/end
here?

Thanks,
    J
