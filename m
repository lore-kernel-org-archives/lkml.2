Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0HZOQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:16:28 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:47611 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753534Ab0HZOQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:16:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ecYiekYVM1kkUVxhm_0QloPfLCvTM39EC1LhcybP4CX5eZb
 gKgoy.GlGdv6UC.jUf2uN90DfeSocDSqLzrIe4UTKNaqt9iTRv9Iju184wU9
 NdypK_oug6ND1C7YbQnCa9JmZpRNBriB5oJlPJPG2R_GKBWgLoyGwKpAUk5Z
 r0hyA2IMWRcw37Iq7o5DaWM.8t3uS3GYlRAW9UkaVqw4CWPYRZyuxLfNdp66
 .PGHF57s7h6uWkTzc30BRl9upWcVv
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 26 Aug 2010 09:16:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>,
        "Ted Ts'o" <tytso@mit.edu>, Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
In-Reply-To: <alpine.DEB.2.00.1008252010260.10986@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008260914420.15852@router.home>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <20100825132417.GQ31488@dastard> <1282743342.2605.3707.camel@laptop> <alpine.DEB.2.00.1008251347550.16484@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008251604120.24931@router.home> <alpine.DEB.2.00.1008251418590.20253@chino.kir.corp.google.com> <alpine.DEB.2.00.1008251630270.25660@router.home> <alpine.DEB.2.00.1008251604540.31521@chino.kir.corp.google.com> <alpine.DEB.2.00.1008252028030.32421@router.home>
 <alpine.DEB.2.00.1008252010260.10986@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, David Rientjes wrote:

> Because we can remove the flag, remove branches from the page allocator
> slowpath, and none of these allocations actually are dependent on
> __GFP_NOFAIL since they are all under PAGE_ALLOC_COSTLY_ORDER.

Then we can simply remove __GFP_NOFAIL? Functions are only needed for
higher order allocs that can fail?

