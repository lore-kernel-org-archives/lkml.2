Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab1FRPLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:11:38 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:43992 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753297Ab1FRPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:11:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RGPRgDLKBkjzL1I9GvWl7gs8Am0sRWs+tW9FrP3dwX6puJUtoaYlaakdDnzfuXuk6+M0zwWJI7n8UNejKgxRraJbpwEH7FBbI7wtfEpslLFqJapQlEig6mUjwfN65ddl;
Date: Sat, 18 Jun 2011 08:11:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hughd@google.com,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
Message-Id: <20110618081134.fbafed0f.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.02.1106181108210.3831@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106181108210.3831@localhost6.localdomain6>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011 11:10:20 -0400 (EDT) Robert P. J. Day wrote:

> 
> Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
> deselect the TMPFS_POSIX_ACL config variable.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 19891aa..4217543 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -127,14 +127,20 @@ config TMPFS_POSIX_ACL
>  	select TMPFS_XATTR
>  	select GENERIC_ACL
>  	help
> -	  POSIX Access Control Lists (ACLs) support permissions for users and
> -	  groups beyond the owner/group/world scheme.
> +	  POSIX Access Control Lists (ACLs) support additional access rights
> +	  for users and groups beyond the standard owner/group/world scheme,
> +	  and this option selects support for ACLs specifically for tmpfs
> +	  filesystems.
> +
> +	  If you've selected TMPFS, you almost certainly want this option
> +	  as well since a number of user space features (e.g., ALSA sound)
> +	  require POSIX ACL support under /dev to work properly.  In other
> +	  words, if you're not sure and you have no *compelling* reason to
> +	  deselect this feature, say Y.
> 
>  	  To learn more about Access Control Lists, visit the POSIX ACLs for
>  	  Linux website <http://acl.bestbits.at/>.
> 
> -	  If you don't know what Access Control Lists are, say N.
> -
>  config TMPFS_XATTR
>  	bool "Tmpfs extended attributes"
>  	depends on TMPFS
> 
> -- 
> 
> ========================================================================
> Robert P. J. Day                                 Ottawa, Ontario, CANADA
>                         http://crashcourse.ca
> 
> Twitter:                                       http://twitter.com/rpjday
> LinkedIn:                               http://ca.linkedin.com/in/rpjday
> ========================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
