Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2DOPcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 11:32:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46377 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2DOPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 11:32:24 -0400
Date: Sun, 15 Apr 2012 16:32:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joel Reardon <joel@clambassador.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: mtdchar kernel oops
Message-ID: <20120415153220.GR6589@ZenIV.linux.org.uk>
References: <alpine.DEB.2.00.1204151350450.13924@eristoteles.iwoars.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204151350450.13924@eristoteles.iwoars.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 01:58:39PM +0200, Joel Reardon wrote:
> I think that this patch:
> "mtdchar: kill persistently held vfsmount"
> http://permalink.gmane.org/gmane.linux.kernel.commits.head/314175
> 
> has started causing kernel oops's when running ubiformat. The oops is
> occuring in fs/namespace.c's mnt_add_count() line:
>         this_cpu_add(mnt->mnt_pcp->mnt_count, n);
> 
> with the stack trace:
> mntget()
> simple_pin_fs()
> mtdchar_open()

Check if commit c65390f4dd49755863f6d772ec538ee4757c08d7
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Apr 9 01:36:28 2012 -0400

    fix breakage in mtdchar_open(), sanitize failure exits

has fixed that.
