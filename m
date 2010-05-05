Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0EEWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:06:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38879 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0EEWGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:06:15 -0400
Message-ID: <4BE1EBC7.4040204@oracle.com>
Date: Wed, 05 May 2010 15:05:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: ebiederm@xmission.com
CC: Greg KH <gregkh@suse.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] sysfs: Don't use enums in inline function declaration.
References: <20100430163538.7253a9e0.sfr@canb.auug.org.au>	<20100430105016.40b51636.randy.dunlap@oracle.com>	<20100505091738.7ec27479.randy.dunlap@oracle.com>	<20100505162459.GA20296@suse.de> <m18w7y10cn.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m18w7y10cn.fsf_-_@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BE1EBCE.01CB:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/10 14:54, ebiederm@xmission.com wrote:
> 
> It appears gcc can't cope with using an enum that is only declared in
> an inline function declaration, that doesn't even use the variable
> that is so declared.
> 
> Avoid the silliness and replace the enum with an int, and make gcc
> happy.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Eric.

> ---
>  include/linux/sysfs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index e58ca1c..17cbeb7 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -318,7 +318,7 @@ static inline void sysfs_put(struct sysfs_dirent *sd)
>  {
>  }
>  
> -static inline void sysfs_exit_ns(enum kobj_ns_type type, const void *tag)
> +static inline void sysfs_exit_ns(int type, const void *tag)
>  {
>  }
>  


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
