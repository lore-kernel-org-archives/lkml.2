Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2BAQ65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:58:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52615 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2BAQ6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:58:55 -0500
MIME-Version: 1.0
In-Reply-To: <1327961644-6886-6-git-send-email-zohar@linux.vnet.ibm.com>
References: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1327961644-6886-6-git-send-email-zohar@linux.vnet.ibm.com>
Date: Wed, 1 Feb 2012 11:58:54 -0500
Message-ID: <CACLa4ptFgmCL7Z4e-YO9XJ_zkr=kOHSJ7cA8u3DPvVc-2LBfRw@mail.gmail.com>
Subject: Re: [RFC][PATCH v1 5/9] ima: allocating iint improvements
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 5:14 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>

>  static struct rb_root integrity_iint_tree = RB_ROOT;
> -static DEFINE_SPINLOCK(integrity_iint_lock);
> +static DEFINE_RWLOCK(integrity_iint_lock);
>  static struct kmem_cache *iint_cache __read_mostly;

Has any profiling been done here?   rwlocks have been shown to
actually be slower on multi processor systems in a number of cases due
to the cache line bouncing required.  I believe the current kernel
logic is that if you have a short critical section and you can't show
profile data the rwlocks are better, just stick with a spinlock.
