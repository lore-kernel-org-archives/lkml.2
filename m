Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1GMM1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:27:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63028 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1GMM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:27:40 -0400
Date: Wed, 13 Jul 2011 14:27:35 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: sys_ssetmask/sys_rt_sigsuspend should use
 set_current_blocked()
Message-ID: <20110713122735.GK2872@htj.dyndns.org>
References: <20110711160102.GA14797@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711160102.GA14797@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 06:01:02PM +0200, Oleg Nesterov wrote:
> sys_ssetmask(), sys_rt_sigsuspend() and compat_sys_rt_sigsuspend()
> change ->blocked directly. This is not correct, see the changelog in
> e6fa16ab "signal: sigprocmask() should do retarget_shared_pending()"
> 
> Change them to use set_current_blocked().
> 
> Another change is that now we are doing ->saved_sigmask = ->blocked
> lockless, it doesn't make any sense to do this under ->siglock.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
