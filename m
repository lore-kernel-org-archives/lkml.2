Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab2ERCvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:51:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43314 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab2ERCvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:51:48 -0400
Date: Thu, 17 May 2012 20:51:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kai.makisara@kolumbus.fi, jeffm@suse.com
Subject: Re: [PATCH 1/5] st: Use static class attributes
Message-ID: <20120518025146.GB19158@parisc-linux.org>
References: <4FB476DD.4020107@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB476DD.4020107@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 08:56:13PM -0700, Lee Duncan wrote:
> @@ -84,7 +84,8 @@ static int try_wdio = 1;
>  static int st_dev_max;
>  static int st_nr_dev;
>  
> -static struct class *st_sysfs_class;
> +extern struct class st_sysfs_class;

Umm ... 'extern' ...

> @@ -4283,6 +4284,11 @@ static void scsi_tape_release(struct kref *kref)
>  	return;
>  }
>  
> +struct class st_sysfs_class = {
> +	.name = "scsi_tape",
> +	.dev_attrs = st_dev_attrs,
> +};

... and then you define it?

I think you meant to say "struct class st_sysfs_class;" at the top,
and then later:

static struct class st_sysfs_class = {
...

> +struct device_attribute st_dev_attrs[] = {

Should also be static


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
