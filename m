Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1HPVak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:30:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50340 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab1HPVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:30:39 -0400
Subject: Re: [PATCH] staging: rtl8712: remove
 r8712_cmd_thread()->daemonize()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110816185057.GA4036@redhat.com>
References: <20110816185057.GA4036@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 22:30:37 +0100
Message-ID: <1313530237.3436.207.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 20:50 +0200, Oleg Nesterov wrote:
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

Acked-by: Matt Fleming <matt.fleming@intel.com>


