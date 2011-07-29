Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab1G2JD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:03:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53174 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab1G2JDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:03:25 -0400
Message-ID: <4E327721.1080605@cn.fujitsu.com>
Date: Fri, 29 Jul 2011 17:02:25 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs:remove a no needed mutex_unlock in devtmpfs
References: <1311928444-4848-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1311928444-4848-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-29 17:02:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-29 17:02:27,
	Serialize complete at 2011-07-29 17:02:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:34 PM, Wanlong Gao wrote:
> According ed75e95de574c99575e5f3e1d9ca59ea8c12a9cb, Al killed the
> lookup_create(), this function will return with an mutex locked,
> and it called by dev_mkdir() previously. then unlock this mutex
> in dev_mkdir(), but when lookup_create() is replaced by kern_path_create(),
> no locked mutex returned, so no need to unlock the mutex.
>
> Al, is it right?
> Thanks
Sorry, kern_path_create() also held a mutex, I made a mistake.
Thanks
>
> Signed-off-by: Wanlong Gao<gaowanlong@cn.fujitsu.com>
> ---
>   drivers/base/devtmpfs.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index b89fffc..5384883 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -157,7 +157,6 @@ static int dev_mkdir(const char *name, mode_t mode)
>   		/* mark as kernel-created inode */
>   		dentry->d_inode->i_private =&thread;
>   	dput(dentry);
> -	mutex_unlock(&path.dentry->d_inode->i_mutex);
>   	path_put(&path);
>   	return err;
>   }


-- 
Thanks
Best Regards
Wanlong Gao
