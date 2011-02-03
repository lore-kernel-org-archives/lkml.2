Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1BCTqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:46:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36539 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab1BCTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:46:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=c8DgYptCjN57CoiJ+ToUFX8fG2gOmNLoI+gUAl/b8U45JqH8ggbZJUxsy0Z2k9A6p6
         gWth1t2HsIHqz1JBiJ/s6e+k57CaL02KmprPSNZezfTr8VzLqr3DxCRjE9oxQCSKXzi6
         QOBVK4aXWIAK5wYEMCkBz29JkktPGcY1An9zk=
Message-ID: <4D4B0611.5010509@gmail.com>
Date: Thu, 03 Feb 2011 22:46:25 +0300
From: "avagin@gmail.com" <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Correctly check d_alloc_name() return code in devpts_pty_new
References: <1296749257-12993-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1296749257-12993-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I found one more similar place, so will send another patch.

On 02/03/2011 07:07 PM, Andrey Vagin wrote:
> d_alloc_name return NULL in case error, but we expect errno in
> devpts_pty_new.
>
> http://bugzilla.openvz.org/show_bug.cgi?id=1758
>
> Signed-off-by: Andrey Vagin<avagin@openvz.org>
> ---
>   fs/devpts/inode.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index 1bb547c..8392c8c 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -501,7 +501,7 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
>   	mutex_lock(&root->d_inode->i_mutex);
>
>   	dentry = d_alloc_name(root, s);
> -	if (!IS_ERR(dentry)) {
> +	if (dentry) {
>   		d_add(dentry, inode);
>   		fsnotify_create(root->d_inode, dentry);
>   	}

