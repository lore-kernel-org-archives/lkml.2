Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2BONxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:53:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38148 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2BONxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:53:11 -0500
Message-ID: <1329313968.2293.109.camel@twins>
Subject: Re: [tip:sched/core] sched: Turn lock_task_sighand() into a static
 inline
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, anton.vorontsov@linaro.org,
        arve@android.com, linux-kernel@vger.kernel.org, san@google.com,
        ebiederm@xmission.com, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, ccross@android.com,
        kosaki.motohiro@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Date: Wed, 15 Feb 2012 14:52:48 +0100
In-Reply-To: <tip-9388dc3047a88bedfd867e9ba3e1980c815ac524@git.kernel.org>
References: <20120209164519.GA10266@oksana.dev.rtsoft.ru>
	 <tip-9388dc3047a88bedfd867e9ba3e1980c815ac524@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 15:10 -0800, tip-bot for Anton Vorontsov wrote:
> +static inline struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
> +                                                      unsigned long *flags)
> +{
> +       struct sighand_struct *ret;
> +
> +       ret = __lock_task_sighand(tsk, flags);
> +       (void)__cond_lock(&tsk->sighand->siglock, ret);
> +       return ret;
> +} 

FWIW, I still really utterly detest __cond_lock(). Ideally someone would
teach sparse the conditional based on return thing and we could do the
function level annotation.
