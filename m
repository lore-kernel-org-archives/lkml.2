Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2CAWds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:33:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2CAWdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:33:47 -0500
Date: Thu, 1 Mar 2012 14:33:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Andrea Righi <andrea@betterlinux.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH -V2 1/9] mm:  move hugetlbfs region tracking function to
 common code
Message-Id: <20120301143345.7e928efe.akpm@linux-foundation.org>
In-Reply-To: <1330593380-1361-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1330593380-1361-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Mar 2012 14:46:12 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> This patch moves the hugetlbfs region tracking function to
> common code. We will be using this in later patches in the
> series.
> 
> ...
>
> +struct file_region {
> +	struct list_head link;
> +	long from;
> +	long to;
> +};

Both Andrea Righi and John Stultz are working on (more sophisticated)
versions of file region tracking code.  And we already have a (poor)
implementation in fs/locks.c.

That's four versions of the same thing floating around the place.  This
is nutty.
