Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab1GSOeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 10:34:03 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:26971 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751008Ab1GSOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 10:34:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7A.lgDoVM1m9PKBUNf18XLGnC5jxzsLHJQKiB8yKcigFidm
 qm7zy.BBUuHxsF0bfyH37QDl4Ww0Fv1oKAIyaMBItH2AM5u93y21FRreQvbJ
 JyTqPP.BX87q0nPGPhje2nMoyfxJU936HvRnC02eMfD_uLF4xRJOaZbqJvpx
 l_2.Q8hqOeStMJM13Z45YKgLibVphgmH_G6RR8UcHELcqEUNjERsBe_nlfnx
 9.vGXAKM.D_YJ3kOGTM876.iIwXWRGzn1RJcFbH44dfI7SK5wLWoYG1FpVXx
 uoSAlCTD0xOVuAWvoDexHz0Qv0XmN1MD619tnwwqBgUOKGZkr3yTOV_AWfqT
 iMa9zWq9S9BsOkJjBs64_qaEn
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 19 Jul 2011 09:33:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
In-Reply-To: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.00.1107190931450.1199@router.home>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, John Stultz wrote:

> Additionally, ashmem introduces the concept of page pinning. Pinned pages (the
> default) behave like any anonymous memory. Unpinned pages are available to the
> kernel for eviction during VM pressure. When repinning the pages, the return
> value instructs user-space as to any eviction. In this manner, user-space
> processes may implement caching and similar resource management that
> efficiently integrates with kernel memory management.

Memory locking (mlock) may be a better term to use here. mlock prevents
eviction. Page pinning also prevents the movement of the pages in memory
(as needed by page migration, compaction etc).

