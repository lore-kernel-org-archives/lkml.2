Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2IZSHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:07:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64421 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab2IZSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:07:15 -0400
Date: Wed, 26 Sep 2012 11:07:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] workqueue: add WORKER_RESCUER
Message-ID: <20120926180711.GB12544@google.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348680043-5077-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:20:32AM +0800, Lai Jiangshan wrote:
> rescuer thread must be a worker which is WORKER_NOT_RUNNING:
> 	If it is *not* WORKER_NOT_RUNNING, it will increase the nr_running
> 	and it disables the normal workers wrongly.
> 
> So rescuer thread must be WORKER_NOT_RUNNING.
> 
> Currently code implement it by always setting WORKER_PREP on rescuer thread,
> but this kind of implement is ugly:
> A)	It reuses WORKER_PREP which is used for a different meaning.
> B)	It does not told us rescuer thread is WORKER_NOT_RUNNING.
> 
> So we add WORKER_RESCUER to fix these two sematic.

Ah, right, we always have WORKER_PREP set for rescuers.  So, this
doesn't actually change the behavior at all?  I'm not necessarily
against it but the commit message seems a bit misleading.

Thanks.

-- 
tejun
