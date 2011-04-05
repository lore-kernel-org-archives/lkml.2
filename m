Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1DEOrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:47:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56851 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab1DEOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:47:06 -0400
Subject: Re: [PATCH] workqueue: Separate out drain_workqueue() from
 destroy_workqueue()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110405143522.GA9621@mtj.dyndns.org>
References: <20110405143522.GA9621@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 07:47:01 -0700
Message-ID: <1302014822.2924.0.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 07:35 -0700, Tejun Heo wrote:
> There are users which want to drain workqueues without destroying it.
> Separate out drain functionality from destroy_workqueue() into
> drain_workqueue() and make it accessible to workqueue users.
> 
> To guarantee forward-progress, only chain queueing is allowed while
> drain is in progress.  If a new work item which isn't chained from the
> running or pending work items is queued while draining is in progress,
> WARN_ON_ONCE() is triggered.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> ---
> James, does this seem to fit your use cases?

Perfectly, thanks.  It makes sure we have eliminated all work the
workqueues generated before we return.  This is needed in some of the
SCSI waits where we want all discovery to complete, not just the piece
the WQ started.

Thanks,

James


