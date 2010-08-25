Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0HYImx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:42:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51625 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0HYImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:42:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Serge Hallyn <serue@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100825071229.GP29330@bicker> (Dan Carpenter's message of "Wed,
	25 Aug 2010 09:12:29 +0200")
References: <20100825071229.GP29330@bicker>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Wed, 25 Aug 2010 01:42:47 -0700
Message-ID: <m1bp8rf5h4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Dan Carpenter <error27@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [patch] sysfs: checking for NULL instead of ERR_PTR
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> writes:

> d_path() returns an ERR_PTR and it doesn't return NULL.
>
> CC:stable@kernel.org
> Signed-off-by: Dan Carpenter <error27@gmail.com>

This is definitely a needed bug fix.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

If we ever get ERR_PTR(-ENAMETOOLONG) and this case actually matters 
something is very wrong with sysfs, but that is another story.

Eric


> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 1b27b56..da3fefe 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -340,7 +340,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
>  	char *p;
>  
>  	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
> -	if (p)
> +	if (!IS_ERR(p))
>  		memmove(last_sysfs_file, p, strlen(p) + 1);
>  
>  	/* need attr_sd for attr and ops, its parent for kobj */
