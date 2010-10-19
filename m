Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0JSRWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:22:09 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:25791 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab0JSRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:22:08 -0400
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
From: Ralph Campbell <ralph.campbell@qlogic.com>
To: Tejun Heo <tj@kernel.org>
CC: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4CBDB834.2050905@kernel.org>
References: <4CBDB834.2050905@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Organization: QLogic
Date: Tue, 19 Oct 2010 10:22:06 -0700
Message-ID: <1287508926.27343.299.camel@chromite.mv.qlogic.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 08:24 -0700, Tejun Heo wrote:

> * qib_cq_wq is a separate singlethread workqueue.  Does the queue
>   require strict single thread execution ordering?  IOW, does each
>   work have to be executed in the exact queued order and no two works
>   should execute in parallel?  Or was the singlethreadedness chosen
>   just to reduce the number of workers?

The work functions need to be called in-order and single threaded
or memory will be freed multiple times and other "bad things".

