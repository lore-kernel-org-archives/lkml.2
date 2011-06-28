Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab1F1P7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:59:04 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37684 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab1F1P4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:56:49 -0400
Date: Tue, 28 Jun 2011 23:56:43 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] PM: Limit race conditions between runtime PM and
 system sleep
Message-ID: <20110628235643.4cf7cff0@tom-ThinkPad-T410>
In-Reply-To: <201106260056.32221.rjw@sisk.pl>
References: <201106260054.20578.rjw@sisk.pl>
	<201106260056.32221.rjw@sisk.pl>
Organization: Ming
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rafael,

On Sun, 26 Jun 2011 00:56:31 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Index: linux-2.6/Documentation/power/runtime_pm.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/runtime_pm.txt
> +++ linux-2.6/Documentation/power/runtime_pm.txt
> @@ -567,6 +567,11 @@ this is:
>  	pm_runtime_set_active(dev);
>  	pm_runtime_enable(dev);
>  
> +The PM core always increments the run-time usage counter before calling the
> +->suspend() callback and decrements it after calling the ->resume() callback.
> +Hence disabling run-time PM temporarily like this will not cause any run-time
> +suspend callbacks to be lost.

Could you explain why the above is that "this will not cause any run-time suspend
callbacks to be lost"? 

Looks like it should be "this will not cause any run-time suspend callbacks to
be called", but not sure.


thanks,
-- 
Ming Lei
