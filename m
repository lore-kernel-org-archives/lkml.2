Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0H0HVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:21:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0H0HVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:21:12 -0400
Date: Fri, 27 Aug 2010 00:24:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Chew <achew@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, alan@linux.intel.com, olof@lixom.net
Subject: Re: [PATCH 1/1] drivers/misc/akm8975: Add compass sensor driver
Message-Id: <20100827002439.8e8df11b.akpm@linux-foundation.org>
In-Reply-To: <20100827091607.1bb889f2@hyperion.delvare>
References: <1282872717-12228-1-git-send-email-achew@nvidia.com>
	<20100827091607.1bb889f2@hyperion.delvare>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 09:16:07 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> > +static int akm_aot_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret = -1;
> 
> Useless and dangerous initialization.
> 
> > +
> > +	FUNCDBG("called");
> > +	if (atomic_cmpxchg(&open_flag, 0, 1) == 0) {
> > +		wake_up(&open_wq);
> > +		ret = 0;

this doesn't do anything either.

> > +	}
> > +
> > +	ret = nonseekable_open(inode, file);
> > +	if (ret)
> > +		return ret;
> > +
> > +	file->private_data = akmd_data;
> > +
> > +	return ret;
> > +}
