Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2ICPJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab2ICPJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:09:41 -0400
Message-ID: <5044C82C.10507@redhat.com>
Date: Mon, 03 Sep 2012 18:09:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Frank Swiderski <fes@google.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, riel@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
References: <1340742778-11282-1-git-send-email-fes@google.com>
In-Reply-To: <1340742778-11282-1-git-send-email-fes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 11:32 PM, Frank Swiderski wrote:
> This implementation of a virtio balloon driver uses the page cache to
> "store" pages that have been released to the host.  The communication
> (outside of target counts) is one way--the guest notifies the host when
> it adds a page to the page cache, allowing the host to madvise(2) with
> MADV_DONTNEED.  Reclaim in the guest is therefore automatic and implicit
> (via the regular page reclaim).  This means that inflating the balloon
> is similar to the existing balloon mechanism, but the deflate is
> different--it re-uses existing Linux kernel functionality to
> automatically reclaim.

Interesting idea.

How is the host able to manage overcommit this way?  If deflate is not
host controlled, the host may start swapping guests out to disk if they
all self-deflate.


-- 
error compiling committee.c: too many arguments to function
