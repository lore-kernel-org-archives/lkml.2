Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1GLSRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:17:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:8266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab1GLSRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:17:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,522,1304319600"; 
   d="scan'208";a="29477387"
Date: Tue, 12 Jul 2011 19:17:30 +0100
From: Matt Fleming <matt.fleming@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: sys_ssetmask/sys_rt_sigsuspend should use
 set_current_blocked()
Message-ID: <20110712191730.3fb554a4@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110711160102.GA14797@redhat.com>
References: <20110711160102.GA14797@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 18:01:02 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

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

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
