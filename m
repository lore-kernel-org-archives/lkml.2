Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1HSQmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:42:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62195 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1HSQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:42:34 -0400
Date: Fri, 19 Aug 2011 13:43:06 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, oleg@redhat.com, Marcel Holtmann <marcel@holtmann.org>,
        Samuel Ortiz <sameo@linux.intel.com>, wwang <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 02/16] freezer: don't unnecessarily set PF_NOFREEZE
 explicitly
Message-ID: <20110819164306.GA24573@joana>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, menage@google.com,
	linux-kernel@vger.kernel.org, arnd@arndb.de, oleg@redhat.com,
	Marcel Holtmann <marcel@holtmann.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	wwang <wei_wang@realsil.com.cn>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

* Tejun Heo <tj@kernel.org> [2011-08-19 16:16:08 +0200]:

> Some drivers set PF_NOFREEZE in their kthread functions which is
> completely unnecessary and racy - some part of freezer code doesn't
> consider cases where PF_NOFREEZE is set asynchronous to freezer
> operations.
> 
> In general, there's no reason to allow setting PF_NOFREEZE explicitly.
> Remove them and change the documentation to note that setting
> PF_NOFREEZE directly isn't allowed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: wwang <wei_wang@realsil.com.cn>
> ---
>  Documentation/power/freezing-of-tasks.txt |    2 +-
>  drivers/bluetooth/btmrvl_main.c           |    2 --
>  drivers/mfd/twl4030-irq.c                 |    3 ---
>  drivers/mfd/twl6030-irq.c                 |    2 --
>  drivers/staging/rts_pstor/rtsx.c          |    2 --
>  5 files changed, 1 insertions(+), 10 deletions(-)

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

	Gustavo
