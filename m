Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1CIAws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:52:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756931Ab1CIAwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:52:46 -0500
Date: Tue, 8 Mar 2011 16:51:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Dave Young <hidave.darkstar@gmail.com>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] sysctl: some input constraints checks were added for
 /proc/sys/vm directory
Message-Id: <20110308165141.3dc7e377.akpm@linux-foundation.org>
In-Reply-To: <1299082575-3084-1-git-send-email-pholasek@redhat.com>
References: <1299082575-3084-1-git-send-email-pholasek@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Mar 2011 17:16:14 +0100
Petr Holasek <pholasek@redhat.com> wrote:

> There were added boundaries of allowed input ranges for: dirty_expire_centisecs,
> drop_caches, overcommit_memory, page-cluster and panic_on_oom.
> 
> ...
>

Well..  It's a non-back-compatible userspace interface change.

Yes, it's unlikely that any userspace was doing, for example, "echo 7 >
/proc/sys/vm/drop_caches".  But if it was, we just broke it.
