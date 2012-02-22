Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2BVWzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:55:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38310 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2BVWzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:55:32 -0500
MIME-Version: 1.0
In-Reply-To: <1329944133-28433-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1329944133-28433-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Wed, 22 Feb 2012 14:55:31 -0800
X-Google-Sender-Auth: 1SD-EtOh2KE2sA7ohkhXm9s40DI
Message-ID: <CAA9_cmc6w_Tn+GbSubCcGxvE2w6yyDyWP_WgY3H5d6iasyqvRQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/scsi/pm8001/pm8001_sas.c: move timer start
From: Dan Williams <dan.j.williams@intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: jack_wang@usish.com, kernel-janitors@vger.kernel.org, lindar_liu@usish.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:55 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Move the add_timer below some instructions that do not seem to require a
> timer and that in one case can fail, thus avoiding the need for a
> corresponding del_timer.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> I don't fully understand the code, and have not tested the change.  Think
> of this patch as more of a question as to whether this is the right thing
> to do.

This patch makes sense to me... don't start the timer until we're sure
that the task is going to be submitted, or at least remember to
del_timer() before returning.

Looks like pm8001_exec_internal_tmf_task() gets this right.

--
Dan
