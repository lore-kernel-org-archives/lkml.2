Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988Ab2B1K0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:26:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45356 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab2B1K0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:26:51 -0500
Date: Tue, 28 Feb 2012 11:27:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhengwang Ruan <ruan.zhengwang@gmail.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Trace: initialize variable to clear warning
Message-ID: <20120228102703.GA6090@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhengwang Ruan <ruan.zhengwang@gmail.com>, rostedt@goodmis.org,
	fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 05:09:34PM +0800, Zhengwang Ruan wrote:
> GCC warns that 'page2' is used without being initialized previously before
> being used, this is to clear it.
> 
> Signed-off-by: Zhengwang Ruan <ruan.zhengwang@gmail.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a3f1bc5..47376ba 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3694,7 +3694,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  	int nr_pages = 1;
>  	ssize_t written;
>  	void *page1;
> -	void *page2;
> +	void *uninitialized_var(page2);
>  	int offset;
>  	int size;
>  	int len;

We had this already - gcc 4.5 warns incorrectly about this, you should
upgrade to 4.6: http://marc.info/?l=linux-kernel&m=132083844427859

-- 
Regards/Gruss,
Boris.
