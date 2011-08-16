Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1HPTft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:35:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47703 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab1HPTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:35:48 -0400
Date: Tue, 16 Aug 2011 21:35:43 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: remove r8712_cmd_thread()->daemonize()
Message-ID: <20110816193543.GD2803@mtj.dyndns.org>
References: <20110816185057.GA4036@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816185057.GA4036@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 08:50:57PM +0200, Oleg Nesterov wrote:
> daemonize() is only needed when a user-space task does kernel_thread().
> 
> r8712_cmd_thread() is kthread_create()'ed and thus it doesn't need
> the soon-to-be-deprecated daemonize(). It is the only caller of
> thread_enter() which actually does the call.
> 
> Note:
> 	- we are going to remove the sigdelset(blocked) code from
> 	  allow_signal(), this means that without this patch
> 	  thread_enter() can't work after that. Not to mention
> 	  daemonize() should be deprecated.
> 
> 	- as a side effect, this patch changes ->comm. Hopefully
> 	  this is fine, and padapter->pnetdev->name probably makes
> 	  more sense anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
