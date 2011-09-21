Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1IUPgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:36:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44985 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1IUPgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <1315494388-2532-1-git-send-email-consul.kautuk@gmail.com>
References: <1315494388-2532-1-git-send-email-consul.kautuk@gmail.com>
Date: Wed, 21 Sep 2011 21:06:52 +0530
Message-ID: <CAFPAmTSTSE=AxWq=uacq0tEPH2Pe99DEisvsn1k0JN8qv2n4ag@mail.gmail.com>
Subject: Re: [PATCH 1/1] Trivial: devtmpfs.c: No need to set the task state to TASK_RUNNING
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>,
        jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please ignore this trivial patch.
I found one more trivial change which I would like to make in this
patch, so I'll resend
this one in a separate email chain.

Thanks,
Kautuk.

On Thu, Sep 8, 2011 at 8:36 PM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
> I think that there should be no need to set the task state to
> TASK_RUNNING as wake_up_process will do that for us.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  drivers/base/devtmpfs.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index a4760e0..8a3f028 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -416,7 +416,6 @@ static int devtmpfsd(void *p)
>                set_current_state(TASK_INTERRUPTIBLE);
>                spin_unlock(&req_lock);
>                schedule();
> -               __set_current_state(TASK_RUNNING);
>        }
>        return 0;
>  out:
> --
> 1.7.4.1
>
>
