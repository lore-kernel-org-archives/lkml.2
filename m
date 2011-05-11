Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1EKQTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:19:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47632 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab1EKQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=o3iBx2jEnfoE8XximhwihZrUnmm32M2tTy4RXKUl4U5+yIos2cY0hOUTGyG/suPKV5
         y8hf3R3+uETT/5hQq4+Z0oYRmWN4S6hOCohylXiki86XDQPldb1x+whdhyum7oYOzMAN
         7twq/dlkRNd6H/9xrDolXqh506luDHK1a3Axc=
MIME-Version: 1.0
In-Reply-To: <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	<1305073386-4810-3-git-send-email-john.stultz@linaro.org>
Date: Wed, 11 May 2011 17:33:34 +0800
Message-ID: <BANLkTikXyqddLbQKyDYFrAwq9DamDj--AQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 8:23 AM, John Stultz <john.stultz@linaro.org> wrote:
> Acessing task->comm requires proper locking. However in the past
> access to current->comm could be done without locking. This
> is no longer the case, so all comm access needs to be done
> while holding the comm_lock.
>
> In my attempt to clean up unprotected comm access, I've noticed
> most comm access is done for printk output. To simpify correct
> locking in these cases, I've introduced a new %ptc format,
> which will safely print the corresponding task's comm.
>
> Example use:
> printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
>

Why do you hide current->comm behide printk?
How is this better than printk("%s: ....", task_comm(current)) ?
