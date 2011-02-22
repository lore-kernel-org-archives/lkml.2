Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1BVU7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:59:03 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42493 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753387Ab1BVU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:58:59 -0500
X-Sasl-enc: Q9cuCnnLeGmXadnJJtyl3hdfJbz5S8iXOR1VGniS0K1c 1298408338
Date: Tue, 22 Feb 2011 17:58:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Carpenter <error27@gmail.com>, Greg KH <gregkh@suse.de>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110222205847.GA1867@khazad-dum.debian.net>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <20110222191333.GA9991@suse.de>
 <20110222192248.GX4000@outflux.net>
 <20110222193314.GA11033@suse.de>
 <20110222202915.GC1966@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222202915.GC1966@bicker>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Dan Carpenter wrote:
> On Tue, Feb 22, 2011 at 11:33:14AM -0800, Greg KH wrote:
> > Again, let's fix the real problems here, world-writable debugfs files.
> 
> We could just ban them?

Eh, if you're serious, maybe add an WARN_ONCE so that the source of the
unwanted DAC bits gets cleaned up?

I do wish this went in.  debugfs is a hazard, both security-wise and
kernel-quality wise.  Anything that has to end up enabled in a distro
kernel really does not belong in debugfs.  In fact, if you would object
to a kernel taint if a feature is used, IMO it certainly don't belong on
debugfs.

> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index e7a7a2f..03ae095 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -223,6 +223,9 @@ struct dentry *debugfs_create_file(const char *name, mode_t mode,
>  
>  	pr_debug("debugfs: creating file '%s'\n",name);
>  
> +	/* don't allow world writable files */
> +	mode &= ~S_IWOTH;
> +
>  	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
>  			      &debugfs_mount_count);
>  	if (error)
> 
> 

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
