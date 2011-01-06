Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab1AFI1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:27:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1AFI1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:27:21 -0500
Message-ID: <4D257CE5.1030001@redhat.com>
Date: Thu, 06 Jan 2011 16:27:17 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, Eric Paris <eparis@redhat.com>
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1294302325-22593-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Forgot Cc'ing Eric Paris, adding.)

> Eric pointed out that kexec_load() actually allows you to
> run any code you want in ring0, this is more like CAP_SYS_MODULE.
>
> Reported-by: Eric Paris<eparis@redhat.com>
> Signed-off-by: WANG Cong<amwang@redhat.com>
>
> ---
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index b55045b..c30d613 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -945,7 +945,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>   	int result;
>
>   	/* We only trust the superuser with rebooting the system. */
> -	if (!capable(CAP_SYS_BOOT))
> +	if (!capable(CAP_SYS_BOOT) || !capable(CAP_SYS_MODULE))
>   		return -EPERM;
>
>   	/*

