Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0IPMyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:54:07 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:47369 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754224Ab0IPMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:54:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ipa+O12/M/TCXPXZWthA0fndSgUNEUVO9FDtW4J+j7JemTQxwTL5frz72Uov1CGYiiJJ/5MWgdIxOkEfjfj/s41Dq5D5xSkZG0+WJbDCMFwBmgAQHh9EuxWx3kRjWtUM;
Date: Thu, 16 Sep 2010 14:53:55 +0200
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: minskey guo <chaohong.guo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, chaohong.guo@intel.com,
        minskey guo <chaohong_guo@linux.intel.com>
Subject: Re: [PATCH]  NULL pointer might be used in ips_monitor()
Message-ID: <20100916145355.24a55114@jbarnes-x201>
In-Reply-To: <1284613588-5199-1-git-send-email-chaohong.guo@linux.intel.com>
References: <1284613588-5199-1-git-send-email-chaohong.guo@linux.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 195.83.197.141 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 13:06:28 +0800
minskey guo <chaohong.guo@linux.intel.com> wrote:

> From: minskey guo <chaohong_guo@linux.intel.com>
> 
>  The patch is to enable creating ips_adjust thread before ips_monitor
>  executes because the latter will kthread_stop() or wake up the former
>  via ips->adjust pointer. Otherwise, it is possible that ips->adjust
> is NULL when kthread_stop() or wake_up_process() is called in
> ips_monitor()
> 
>  Besides, some trival changes:
>    a) correct an define of register bits;
>    b) old_cpu_power sample should not be divided by 65535
>    c) handling on error path in ips_get_i915_syms()

Excellent, thanks for the fixes.  Can you split up the patch into
individual fixes and send them over to the platform driver list and
Matthew Garrett?  You can add my acked-by on them.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
