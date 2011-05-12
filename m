Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab1ELWAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:00:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab1ELWAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nxsFC5SalTa3FXN3dLAebGLP0eS+/YrQZaTXPD0MNUHq/bLK54OgCQJWGjOt5isWJp
         ynyBPVfZYkpdDiPX1hjA==
Date: Thu, 12 May 2011 15:00:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect task->comm
 access
In-Reply-To: <1305073386-4810-2-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.00.1105121458130.7530@chino.kir.corp.google.com>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org> <1305073386-4810-2-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, John Stultz wrote:

> The implicit rules for current->comm access being safe without locking
> are no longer true. Accessing current->comm without holding the task
> lock may result in null or incomplete strings (however, access won't
> run off the end of the string).
> 
> In order to properly fix this, I've introduced a comm_lock seqlock
> which will protect comm access and modified get_task_comm() and
> set_task_comm() to use it.
> 
> Since there are a number of cases where comm access is open-coded
> safely grabbing the task_lock(), we preserve the task locking in
> set_task_comm, so those users are also safe.
> 
> With this patch, users that access current->comm without a lock
> are still prone to null/incomplete comm strings, but it should
> be no worse then it is now.
> 
> The next step is to go through and convert all comm accesses to
> use get_task_comm(). This is substantial, but can be done bit by
> bit, reducing the race windows with each patch.
> 
> CC: Ted Ts'o <tytso@mit.edu>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: David Rientjes <rientjes@google.com>
> CC: Dave Hansen <dave@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: David Rientjes <rientjes@google.com>
