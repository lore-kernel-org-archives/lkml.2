Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1LSUxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:53:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50368 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1LSUxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:53:04 -0500
Date: Mon, 19 Dec 2011 20:52:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111219205251.GK2203@ZenIV.linux.org.uk>
References: <1324265775.25089.20.camel@mengcong>
 <4EEEE866.2000203@linux.vnet.ibm.com>
 <4EEF0003.3010800@codeaurora.org>
 <4EEF1A13.4000801@linux.vnet.ibm.com>
 <20111219121100.GI2203@ZenIV.linux.org.uk>
 <4EEF9D4E.1000008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF9D4E.1000008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 01:53:42AM +0530, Srivatsa S. Bhat wrote:
> If this new definition of our requirement is acceptable (correct me if I am
> wrong), then we can do something like the following patch, while still
> retaining br locks as non-blocking.
> 
> We make a copy of the current cpu_online_mask, and lock the per-cpu locks of
> all those cpus. Then while unlocking, we unlock the per-cpu locks of these cpus
> (by using that temporary copy of cpu_online_mask we created earlier), without
> caring about the cpus actually online at that moment.
> IOW, we do lock-unlock on the same set of cpus, and that too, without missing
> the complete lock-unlock sequence in any of them. Guaranteed.

	And what's to stop a process on a newly added CPU from _not_
spinning in br_read_lock(), even though br_write_unlock() hadn't been
done yet?
