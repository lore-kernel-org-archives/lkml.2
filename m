Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2F0Jk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2F0Jkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:40:55 -0400
Date: Wed, 27 Jun 2012 15:10:46 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Frank Swiderski <fes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, riel@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>, mikew@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
Message-ID: <20120627094046.GE19023@amit.redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340742778-11282-1-git-send-email-fes@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 26 Jun 2012 [13:32:58], Frank Swiderski wrote:
> This implementation of a virtio balloon driver uses the page cache to
> "store" pages that have been released to the host.  The communication
> (outside of target counts) is one way--the guest notifies the host when
> it adds a page to the page cache, allowing the host to madvise(2) with
> MADV_DONTNEED.  Reclaim in the guest is therefore automatic and implicit
> (via the regular page reclaim).  This means that inflating the balloon
> is similar to the existing balloon mechanism, but the deflate is
> different--it re-uses existing Linux kernel functionality to
> automatically reclaim.

This is a good idea for a guest co-operative balloon driver.  I don't
think it'll replace the original driver.  The traditional balloon
model is essentially driven by the host to increase guest density on
the host.  This driver can't work in that case.  However, using both
the types of drivers will be helpful, as unused pages on the guest
will be able to be used by the host.

Balbir Singh had done some work earlier on a guest co-operative
balloon driver, but AFAIR it was with modification of the existing
virtio-balloon driver.

I don't think a separate driver is necessary for the functionality,
though.  Perhaps just a new config space item which mentions how many
pages are present in the page cache, so that host do some accounting
as well.

		Amit
