Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2FZUlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab2FZUlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:41:21 -0400
Message-ID: <4FEA1E2E.4020806@redhat.com>
Date: Tue, 26 Jun 2012 16:40:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Frank Swiderski <fes@google.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com,
        Ying Han <yinghan@google.com>, Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
References: <1340742778-11282-1-git-send-email-fes@google.com>
In-Reply-To: <1340742778-11282-1-git-send-email-fes@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 04:32 PM, Frank Swiderski wrote:
> This implementation of a virtio balloon driver uses the page cache to
> "store" pages that have been released to the host.  The communication
> (outside of target counts) is one way--the guest notifies the host when
> it adds a page to the page cache, allowing the host to madvise(2) with
> MADV_DONTNEED.  Reclaim in the guest is therefore automatic and implicit
> (via the regular page reclaim).  This means that inflating the balloon
> is similar to the existing balloon mechanism, but the deflate is
> different--it re-uses existing Linux kernel functionality to
> automatically reclaim.
>
> Signed-off-by: Frank Swiderski<fes@google.com>

It is a great idea, but how can this memory balancing
possibly work if someone uses memory cgroups inside a
guest?

Having said that, we currently do not have proper
memory reclaim balancing between cgroups at all, so
requiring that of this balloon driver would be
unreasonable.

The code looks good to me, my only worry is the
code duplication. We now have 5 balloon drivers,
for 4 hypervisors, all implementing everything
from scratch...
