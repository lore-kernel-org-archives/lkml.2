Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2DWUkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:40:53 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62417 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2DWUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:40:52 -0400
Date: Mon, 23 Apr 2012 13:40:48 -0700
From: greg <gregkh@linuxfoundation.org>
To: yan <clouds.yan@gmail.com>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Subject: Re: [PATCH 3/4][Trivial] lib/kobject.c : Check ktype in
 kobject_add_internal
Message-ID: <20120423204048.GC13075@kroah.com>
References: <1335002414.2188.27.camel@yan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335002414.2188.27.camel@yan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 05:58:31PM +0800, yan wrote:
> If someone calls kobject_init with null kobj_type, kobject_init can 
> detect it. But it does not have a return value, it just dumps stack.
> In this case, a kobject_add after that will result in:
>    -->kobject_add_varg
>     -->kobject_add_internal
>      -->create_dir
>       -->sysfs_create_dir
>        -->sysfs_read_ns_type
>         -->kobj_child_ns_ops
> In the end, it will call ->ktype->child_ns_type directly and we have
> an oops.
> 
> Check ktype before really add a kobject.

But how can we add a kobject without a valid ktype?

At the most, I'd prefer to warn about this, much like we warn about not
having a name, and not just returning an error without a hint as to what
went wrong.

greg k-h
