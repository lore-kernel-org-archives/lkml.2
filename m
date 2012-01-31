Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2AaOll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:41:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40532 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2AaOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:41:40 -0500
Message-ID: <4F27FDA0.6090806@suse.cz>
Date: Tue, 31 Jan 2012 15:41:36 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] sysfs:  Update the name hash when renaming sysfs entries
References: <4F27120A.4040106@suse.cz> <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com> <4F27C54F.1010107@suse.cz> <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com> <4F27C9D4.3040105@suse.cz> <CAPXgP12pj6esZVmN-PYTVgJ+_MaAfmpa9hKoKKQZ+Y=Y-Kb4eA@mail.gmail.com> <4F27CDBC.5020201@suse.cz> <CAPXgP1371fgmaP3ecxsDJ2BmJrOS6kUP95G1BHe6deBPk5FVCQ@mail.gmail.com> <m18vko6jmv.fsf@fess.ebiederm.org> <m1zkd45411.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1zkd45411.fsf_-_@fess.ebiederm.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 03:40 PM, Eric W. Biederman wrote:
> 
> This fixes a bug introduced with sysfs name hashes where renaming a
> network device appears to succeed but silently makes the sysfs files for
> that network device inaccessible.
> 
> In at least one configuration this bug has stopped networking from
> coming up during boot.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

It works for me. Thanks.

Tested-by: Jiri Slaby <jslaby@suse.cz>

> ---
>  fs/sysfs/dir.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index ea64d01..dd3779c 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -872,6 +872,7 @@ int sysfs_rename(struct sysfs_dirent *sd,
>  
>  		dup_name = sd->s_name;
>  		sd->s_name = new_name;
> +		sd->s_hash = sysfs_name_hash(sd->s_ns, sd->s_name);
>  	}
>  
>  	/* Move to the appropriate place in the appropriate directories rbtree. */


-- 
js
suse labs
