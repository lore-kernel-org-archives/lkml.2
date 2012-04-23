Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2DWUn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:43:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39789 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2DWUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:43:26 -0400
Date: Mon, 23 Apr 2012 13:43:22 -0700
From: greg <gregkh@linuxfoundation.org>
To: yan <clouds.yan@gmail.com>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Subject: Re: [PATCH][Trivial] lib/kobject.c: Remove redundant check in
 populate_dir
Message-ID: <20120423204322.GE13075@kroah.com>
References: <1335003508.2188.44.camel@yan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335003508.2188.44.camel@yan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 06:18:25PM +0800, yan wrote:
> create_dir will call sysfs_create_dir and then populate_dir.
> If ktype of kobject is null, sysfs_craete_dir will lead to
> oops first. There is no need to check ktype in populate_dir.
> 
> Signed-off-by: Yan Hong <clouds.yan@gmail.com>
> ---
>  lib/kobject.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index bc05922..85d5e9b 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -34,7 +34,7 @@ static int populate_dir(struct kobject *kobj)
>  	int error = 0;
>  	int i;
>  
> -	if (t && t->default_attrs) {
> +	if (t->default_attrs) {

I don't know, I think I'd like to keep this check for now, as it was put
there for a reason.  Yes, it's a reason lost to the sands of time, but
is it costing us anything if it is still there?

greg k-h
