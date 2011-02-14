Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1BNO4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:56:06 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:53802 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1BNO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r8Roq7Mp5LKyegKrdn7Yu/v0Q9VrbS8nhJdl6AQSFY8ouB3ViCFf/E8vLwDHFQz6ws
         8u5iM80CKkq+Bb8RXQ0ST7RXmhTbww/P4GoSIAcwYGWFxM5EEGyl5Iy0sXLrr2E5d7Cg
         E6PbqZSRmL870HwezNUXFfeuoeSMiPe0GFq+k=
Date: Mon, 14 Feb 2011 22:55:49 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Why does the 2.6.37 scheduler hate RT tasks?
Message-ID: <20110214145549.GB2937@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110202011049.GA15084@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110202011049.GA15084@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 05:10:49PM -0800, Paul E. McKenney wrote:
> Hello, Peter,
> 
> If I create an SCHED_FIFO-priority kthread in pre-2.6.37 kernels,
> things work nicely.  If I try in in later kernels, __disable_runtime()
> gets upset occasionally during CPU-hotplug calls when CPUs are inserted.
> If I make the exact same kthreads run SCHED_NORMAL, no problem.
> 
> Unfortunately, I need an RT kthread so that I can do priority boosting.
> 
> My next thing to try is to demote my kthreads to SCHED_NORMAL at the
> beginning of a CPU-hotplug event and promote them back to SCHED_FIFO at
> the end of the CPU-hotplug event, which would leave the system vulnerable
> to RCU priority inversion during CPU-hotplug events.  This would be
> better than the current behavior, but I thought that I should check with
> you to see if there is a better approach.

Just want to know the status of this issue :)

Does commit 06c3bc655697b19521901f9254eb0bbb2c67e7e8 cure it?

Thanks,
Yong
