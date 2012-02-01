Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2BAGKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:10:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37824 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2BAGKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:10:01 -0500
Message-ID: <4F28D72F.8060505@gmail.com>
Date: Wed, 01 Feb 2012 14:09:51 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] Fix race in process_vm_rw_core
References: <20120130124406.1567af7a@Gantu.yeoh.info> <20120130150922.GA17643@redhat.com> <20120201162330.43d421d3@Gantu.yeoh.info>
In-Reply-To: <20120201162330.43d421d3@Gantu.yeoh.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 01:53 PM, Christopher Yeoh wrote:
> +	mm = mm_access(task, PTRACE_MODE_ATTACH);
> +	if (!mm || IS_ERR(mm)) {
> +		if (!mm)
> +			rc = -EINVAL;
> +		else
> +			rc = -EPERM;
>   		goto put_task_struct;

If IS_ERR(mm), you need to return PTR_ERR(mm), rather than -EPERM.

And, is -EINVAL proper for !mm case? For me, -ENOENT is better.
