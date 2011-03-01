Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab1CAWZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:25:00 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:54964 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab1CAWY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=Xifnew
	qXZEy1OYF26dbwD3+HrPR+Cv0TY/53N7hNlIubAns69IuMXFYOirv9Y87EYPYIlM
	7kPL7LeXwgwutc0bKrphliVjSPH4ex/SLOqrZq6Gua0u4JkHrBOKxZmLwMYcxB+6
	nPxGmtscXBlGKOzlhDWFXxLpuQsgkIfHrkDEI=
Subject: Re: [PATCH 09/10] userns: check user namespace for task->file uid
 equivalence checks
From: Nathan Lynch <ntl@pobox.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        LSM <linux-security-module@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20110224150315.GI8262@mail.hallyn.com>
References: <20110224150150.GA8262@mail.hallyn.com>
 <20110224150315.GI8262@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 16:24:41 -0600
Message-ID: <1299018281.461.16.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: E957B0AE-4452-11E0-9C36-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 15:03 +0000, Serge E. Hallyn wrote:
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1446,8 +1446,13 @@ enum {
>  #define put_fs_excl() atomic_dec(&current->fs_excl)
>  #define has_fs_excl() atomic_read(&current->fs_excl)
>  
> -#define is_owner_or_cap(inode)	\
> -	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
> +/*
> + * until VFS tracks user namespaces for inodes, just make all files
> + * belong to init_user_ns
> + */
> +extern struct user_namespace init_user_ns;

init_user_ns gets declared in fs.h in this patch, utsname.h in patch #1,
capability.h in #2, ipc_namespace.h in #7.  Could this declaration be
kept to a single header?


