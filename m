Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2DFHyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:54:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49937 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2DFHx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:53:59 -0400
X-AuditID: b753bd60-a3089ba000000655-6b-4f7ea1142586
X-AuditID: b753bd60-a3089ba000000655-6b-4f7ea1142586
Message-ID: <4F7EA0E8.1070809@hitachi.com>
Date: Fri, 06 Apr 2012 16:53:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] Kprobes : Recursively remove the directory on failure
References: <1333467303-20130-1-git-send-email-sasikanth.v19@gmail.com>
In-Reply-To: <1333467303-20130-1-git-send-email-sasikanth.v19@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/04 0:35), Sasikantha babu wrote:
> Remove the "kprobes" directory recursivly if "enabled" file creation fails
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>

Right,  this should remove recursively, because there is
"list" file already.
Thank you!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  kernel/kprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index c62b854..9b45515 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2251,7 +2251,7 @@ static int __kprobes debugfs_kprobe_init(void)
>  	file = debugfs_create_file("enabled", 0600, dir,
>  					&value, &fops_kp);
>  	if (!file) {
> -		debugfs_remove(dir);
> +		debugfs_remove_recursive(dir);
>  		return -ENOMEM;
>  	}
>  


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
