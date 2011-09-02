Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab1IBA3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:29:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54887 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab1IBA3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:29:25 -0400
Date: Fri, 2 Sep 2011 09:29:17 +0900
From: Tejun Heo <tj@kernel.org>
To: Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
Message-ID: <20110902002917.GD2752@htj.dyndns.org>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 01, 2011 at 02:36:33PM +0100, Ripduman Sohan wrote:
> Rescuer threads may be migrated (and are bound) to particular CPUs when
> active.  However, the allowed_cpus mask is not restored when they return
> to sleep rendering inconsistent the presented and actual set of CPUs the
> process may potentially run on.  This patch fixes this oversight by
> recording the allowed_cpus mask for rescuer threads when it enters the
> rescuer_thread() main loop and restoring it every time the thread sleeps.

Hmmm... so, currently, rescuer is left bound to the last cpu it worked
on.  Why is this a problem?

Thanks.

-- 
tejun
