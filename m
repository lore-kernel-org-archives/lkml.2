Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab1BRDsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:48:52 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39981 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1BRDst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:48:49 -0500
Date: Thu, 17 Feb 2011 21:48:44 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ecryptfs: read on a directory should return EISDIR
 if not supported
Message-ID: <20110218034843.GF24444@boyd.l.tihix.com>
References: <1297831799-5169-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297831799-5169-1-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Feb 16, 2011 at 04:49:59AM +0000, Andy Whitcroft <apw@canonical.com> wrote:
> read() calls against a file descriptor connected to a directory are
> incorrectly returning EINVAL rather than EISDIR:
> 
>   [EISDIR]
>     [XSI] [Option Start] The fildes argument refers to a directory and the
>     implementation does not allow the directory to be read using read()
>     or pread(). The readdir() function should be used instead. [Option End]
> 
> This occurs because we do not have a .read operation defined for
> ecryptfs directories.  Connect this up to generic_read_dir().
> 
> BugLink: http://bugs.launchpad.net/bugs/719691
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Thanks Andy - applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Tyler

> ---
>  fs/ecryptfs/file.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> index 81e10e6..7d1050e 100644
> --- a/fs/ecryptfs/file.c
> +++ b/fs/ecryptfs/file.c
> @@ -317,6 +317,7 @@ ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> 
>  const struct file_operations ecryptfs_dir_fops = {
>  	.readdir = ecryptfs_readdir,
> +	.read = generic_read_dir,
>  	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl = ecryptfs_compat_ioctl,
> -- 
> 1.7.1
> 
