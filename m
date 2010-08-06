Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433Ab0HFO6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:58:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:60573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab0HFO56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:57:58 -0400
Subject: Re: [RFC PATCH 4/9] mce: Add persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: acme@infradead.org, fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
In-Reply-To: <1281104713-23141-5-git-send-email-bp@amd64.org>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
	 <1281104713-23141-5-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 06 Aug 2010 16:57:16 +0200
Message-ID: <1281106636.1947.710.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 16:25 +0200, Borislav Petkov wrote:
> +static const struct file_operations perf_mce_fops = {
> +       .llseek         = no_llseek,
> +       .open           = mce_perf_open,
> +       .poll           = perf_poll,
> +       .unlocked_ioctl = perf_ioctl,
> +       .compat_ioctl   = perf_ioctl,
> +       .mmap           = perf_mmap,
> +       .fasync         = perf_fasync,
> +       .release        = perf_release,
> +}; 

I'd rather see this part of the persistent bits live in
kernel/perf_event.c, that way you don't need the previous patch either.


