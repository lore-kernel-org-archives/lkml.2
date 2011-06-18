Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1FROxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 10:53:08 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:48184 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752397Ab1FROxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 10:53:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=r5bq0aj9ngEDcc7vcQq/VBqdkXIzwc2+cjDdAzy0zJdVvl9TB4Nz3GiTm8hv/TcyHWtjN0LWviPVnKhxwuFKLpITL81oTAyuEQzC0YPXyntej+fpMOvL74OFU0+s61Lw;
Date: Sat, 18 Jun 2011 07:53:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hughd@google.com
Subject: Re: [PATCH] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
Message-Id: <20110618075301.b4d3816c.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011 07:45:35 -0400 (EDT) Robert P. J. Day wrote:

> 
> Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
> deselect the TMPFS_POSIX_ACL config variable.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
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
> +	  as well since a number of user space features (ie., ALSA sound)

	                                                 e.g.,
?

Otherwise, looks good to me.
Thanks.

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


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
