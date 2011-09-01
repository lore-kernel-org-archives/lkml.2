Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1IAJuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:50:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:40299 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab1IAJuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:50:05 -0400
Subject: Re: [PATCH 09/24] C6X: signal management
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
In-Reply-To: <1314826019-22330-10-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-10-git-send-email-msalter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 10:50:03 +0100
Message-ID: <1314870603.8038.27.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 17:26 -0400, Mark Salter wrote:
> +static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
> +			   sigset_t *set, struct pt_regs *regs)
> +{
> +	struct rt_sigframe __user *frame;
> +	unsigned long __user *retcode;
> +	int err = 0;
> +
> +	frame = get_sigframe(ka, regs, sizeof(*frame));
> +
> +	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
> +		goto segv_and_exit;

[...]

> +segv_and_exit:
> +	force_sig(SIGSEGV, current);
> +	return -EFAULT;
> +}

Shouldn't that really be a call to force_sigsegv(signr, current) ?


