Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2KMRyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:54:04 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:55911 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2KMRx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:53:58 -0500
Date: Tue, 13 Nov 2012 21:53:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-epoll-add-procfs-fdinfo-helper.patch added to -mm tree
Message-ID: <20121113175352.GN7808@moon>
References: <20121113145050.GA13691@redhat.com>
 <20121113155313.GU6511@moon>
 <20121113162056.GK7808@moon>
 <20121113164951.GA18665@redhat.com>
 <20121113170159.GW6511@moon>
 <20121113171422.GM7808@moon>
 <20121113174706.GA20626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113174706.GA20626@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 06:47:06PM +0100, Oleg Nesterov wrote:
> On 11/13, Cyrill Gorcunov wrote:
> >
> > On Tue, Nov 13, 2012 at 09:01:59PM +0400, Cyrill Gorcunov wrote:
> > >
> > The sigmask is read in lockless manner for a sake of
> > code simplicity, thus if precise data needed here
> > the tasks which refer to the signalfd should be
> > stopped before read.
> 
> Yes, I think this is fine, and this patch should replace
> fs-epoll-add-procfs-fdinfo-helper.patch in -mm.

No, epoll is different one, this patch is for
fdinfo-show-sigmask-for-signalfd-fd.patch, I'll send
the updates as new series.
 
> >  static const struct file_operations signalfd_fops = {
> > +#ifdef CONFIG_PROC_FS
> > +	.show_fdinfo	= signalfd_show_fdinfo,
> > +#endif
> 
> I am just curious and I can't find the patch which adds .show_fdinfo.
> Could you please send me link/patch offlist?

It is titled as procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
Sure I'll resend you it offlist in a minute.

	Cyrill
