Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2C1Ial (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:30:41 -0400
Received: from mga06.intel.com ([134.134.136.21]:11368 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751805Ab2C1Iai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <1331834850-27409-1-git-send-email-don.morris@hp.com>
References: <1331834850-27409-1-git-send-email-don.morris@hp.com>
Date: Wed, 28 Mar 2012 01:30:37 -0700
Message-ID: <CABE8wwsP+o9AeSYW1wUJLfZ6y1v9c8EXT8b3nfTDiDdKW0fA+A@mail.gmail.com>
Subject: Re: [PATCH V2] iop-adma: Corrected array overflow in RAID6 Xscale(R) test.
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Don Morris <don.morris@hp.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:07 AM, Don Morris <don.morris@hp.com> wrote:
> Bug: cppcheck reported overflow in array assignment (for loop walks
> 0 to IOP_ADMA_NUM_SRC_TEST+2, array size is IOP_ADMA_NUM_SRC_TEST).
>
> Reported as: https://bugzilla.kernel.org/show_bug.cgi?id=42677
>
> Test code pq_src array was grown by two elements to correspond with actual
> usage (IOP_ADMA_NUM_SRC_TEST+2), stack consumption was kept constant by
> modifying the pq_dest two element array which is only used when pq_src
> is referenced up to IOP_ADMA_NUM_SRC_TEST elements into the address
> of the new last two elements of the pq_src array. This is presumed to
> be the original intent but would be reliant on compilers always having
> pq_dest contiguous with the final element of pq_src.
>
> Note: This is a re-send of a request for review from two weeks ago.
> Looking for review (or shootdown), adding LKML to list for a wider
> audience. Thanks.
>
> Updated per review comments of Sergei Shtylyov <sshtylyov@mvista.com>
>
> Signed-off-by: Don Morris <don.morris@hp.com>

Applied, thanks, and I'll send it along for Vinod's tree.
