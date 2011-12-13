Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1LMWXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:23:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33488 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab1LMWXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:23:02 -0500
Date: Wed, 14 Dec 2011 02:22:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs
 files v2
Message-ID: <20111213222256.GD2618@moon>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323812733-7520-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 01:45:32PM -0800, Andi Kleen wrote:
>  
> +/*
> + * Created parents stay around later. Sorry, but it shouldn't be a big issue.
> + */
> +static const char *create_parents(const char *name, struct dentry *parent,
> +				  struct dentry **pp, int *ref)
> +{
> +	char fn[strlen(name) + 1];
> +	char *tail;
> +	char *s, *p;
> +	struct dentry *new_parent, *dentry, *old_parent = NULL;
> +
> +	strcpy(fn, name);
> +	tail = strrchr(fn, '/');
> +	if (!tail)
> +		return name;
> +	tail++;
> +

Hi Andi, is it possible to do say kstrdup or something instead of
variable-size array in fn[strlen(name) + 1] ? As far as I remember
we already had some warnings with them at least in perf land (or
trace land). Or I miss something?

	Cyrill
