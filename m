Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1LAVex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:34:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1LAVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:34:52 -0500
Date: Thu, 1 Dec 2011 13:34:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH RESEND] NUMA x86: add constraints check for nid
 parameters
Message-Id: <20111201133451.5fc1ee7b.akpm@linux-foundation.org>
In-Reply-To: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Dec 2011 12:45:07 +0100
Petr Holasek <pholasek@redhat.com> wrote:

> This patch adds constraints checks into __node_distance() and
> numa_set_distance() functions. If from or to parameters are
> lower than zero, it results into oops now.

Passing negative numbers into __node_distance() sounds like a bug in
the caller, and this patch will remove our means of detecting that bug.

Perhaps we need to be told more about this patch.  Is the bug
user-triggerable?  If so, how?  How was this fault triggered? 
Etcetera.

