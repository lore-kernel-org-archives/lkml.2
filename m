Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2BBQ2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:28:48 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:65171 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751946Ab2BBQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:28:46 -0500
Message-ID: <1328200126.3232.30.camel@deadeye>
Subject: Re: [PATCH 3/4] sysctl: Comments to make the code clearer.
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 2 Feb 2012 16:28:46 +0000
In-Reply-To: <m1pqdxvroc.fsf_-_@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	 <m139atx6bs.fsf@fess.ebiederm.org> <m1pqdxvroc.fsf_-_@fess.ebiederm.org>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18684.005
X-TM-AS-Result: No--16.648700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 19:29 -0800, Eric W. Biederman wrote:
> Document get_subdir and that find_subdir alwasy takes a reference.
> 
> Suggested-by:  Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/proc/proc_sysctl.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 722ec11..e5601dc 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -73,6 +73,7 @@ static int namecmp(const char *name1, int len1, const char *name2, int len2)
>  	return cmp;
>  }
>  
> +/* Called under sysctl_lock */
>  static struct ctl_table *find_entry(struct ctl_table_header **phead,
>  	struct ctl_dir *dir, const char *name, int namelen)
>  {
> @@ -864,6 +865,18 @@ static struct ctl_dir *new_dir(struct ctl_table_set *set,
>  	return new;
>  }
>  
> +/**
> + * get_subdir - find or create a subdir with the specified name.
> + * @dir:  Directory to create the subdirectory in
> + * @name: The name of the subdirectory to find or create
> + * @namelen: The length of name
> + *
> + * Takes a directory with an elevated reference count so we know that
> + * if we drop the lock the directory will not go away.  Upon success
> + * the reference is moved from @dir to the returned subdirectory.
> + * Upon error an error code is returned and the reference on @dir is
> + * simply dropped.
> + */
>  static struct ctl_dir *get_subdir(struct ctl_dir *dir,
>  				  const char *name, int namelen)
[...]

Should static functions really have kernel-doc?  (Aside from static
inlines defined in a header.)  This can pollute the documentation
namespace.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

