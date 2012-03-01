Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab2CABic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:38:32 -0500
Received: from ozlabs.org ([203.10.76.45]:52690 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab2CABib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:38:31 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty.russell@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: Re: [PATCH] module: debugging check for runaway kthreads
In-Reply-To: <1330528873-7738-1-git-send-email-dmitry.antipov@linaro.org>
References: <1330528873-7738-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 01 Mar 2012 12:06:54 +1030
Message-ID: <87vcmp14qx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 19:21:13 +0400, Dmitry Antipov <dmitry.antipov@linaro.org> wrote:
> Debugging option CONFIG_MODULE_KTHREAD_CHECK provides a way to check
> whether all kernel threads created by the module and have used module
> code as a thread worker function are really exited when the module is
> unloaded. The following pseudo-code contains example of an error which
> is likely to be catched with this debugging check:

Nice idea, but that's 101 lines of code, for very little gain.

How about a debug option which unmaps all module pages on removal,
and ensures they don't get reused?  That might catch a multitude of
problems.  And yes, I realize it might be a bigger patch...

Thanks,
Rusty.
