Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1CNXrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:47:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab1CNXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:47:39 -0400
Date: Mon, 14 Mar 2011 16:46:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v9 3/3] cgroups: introduce timer slack controller
Message-Id: <20110314164652.5b44fb9e.akpm@linux-foundation.org>
In-Reply-To: <1300111524-5666-4-git-send-email-kirill@shutemov.name>
References: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
	<1300111524-5666-4-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 16:05:24 +0200
Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> +Overview
> +--------
> +
> +Every task_struct has timer_slack_ns value. This value uses to round up
> +poll() and select() timeout values. This feature can be useful in
> +mobile environment where combined wakeups are desired.
> +
> +Originally, prctl() was the only way to change timer slack value of
> +a process. So you was not able change timer slack value of another
> +process.
> +
> +cgroup subsys "timer_slack" implements timer slack controller. It
> +provides a way to set minimal timer slack value for a group of tasks.
> +If a task belongs to a cgroup with minimal timer slack value higher than
> +task's value, cgroup's value will be applied.
> +
> +Timer slack controller allows to implement setting timer slack value of
> +a process based on a policy. For example, you can create foreground and
> +background cgroups and move tasks between them based on system state.

(quoting myself from last time)

Why do we need a cgroup for this as opposed to (say) inheritance over
fork(), or a system-wide knob, or a per-process/threadgroup knob, or
just leaving the existing code as-is?  Presumably you felt that a
cgroup approach is better for manageability, but you didn't tell us
about this and you didn't explore alternative ways of solving the
problem-which-you-didn't-describe.




I'm still having trouble seeing why we should merge this.  Who will use
it, and for what reason and what benefits will they see?  Quantified
benefits, if possible!

