Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1F2Klm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:41:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64686 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1F2Klj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-2-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-2-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 29 Jun 2011 12:41:18 +0200
X-Google-Sender-Auth: dFPGTKImSyDB0g8tndKZhMwW2G0
Message-ID: <BANLkTin-t=OTpOMsZDxokbPrYeOH4iQ6vA@mail.gmail.com>
Subject: Re: [PATCH 01/11] dynamic_debug: allow changing of dynamic_debug
 verbosity any time
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> allow changing dynamic_debug verbosity
> at boot-time, with: dynamic_debug.verbose=1
> or at runtime with:
> root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 75ca78f..a3b08d5 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -58,6 +58,7 @@ struct ddebug_iter {
>  static DEFINE_MUTEX(ddebug_lock);
>  static LIST_HEAD(ddebug_tables);
>  static int verbose = 0;
> +module_param(verbose, int, 0744);

Why 0744 and not 0644 ? Why to set the 'executable' bit ?

Bart.
