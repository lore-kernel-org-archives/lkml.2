Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2IWGex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 02:34:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47519 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2IWGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 02:34:52 -0400
Date: Sun, 23 Sep 2012 07:34:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 3/4] devpts: Make the newinstance option historical
Message-ID: <20120923063445.GA26640@ZenIV.linux.org.uk>
References: <20120124220247.GA26353@hallyn.com>
 <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
 <20120124231601.GA4470@sergelap>
 <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
 <20120128195103.GA11299@sergelap>
 <87txup763i.fsf_-_@xmission.com>
 <87d31d75yj.fsf_-_@xmission.com>
 <20120923041906.GM13973@ZenIV.linux.org.uk>
 <87bogx5lg7.fsf@xmission.com>
 <20120923063038.GO13973@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120923063038.GO13973@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 07:30:38AM +0100, Al Viro wrote:
> On Sat, Sep 22, 2012 at 10:59:04PM -0700, Eric W. Biederman wrote:
> 
> > The test:
> > >> +	if (filp->f_vfsmnt->mnt_root == filp->f_dentry)
> > kicks in and no redirection is performed.
> 
> Umm...  OK, after the first round of recursion.  Unless you bind /something/pts
> on /something.

Other way round, of course...  E.g.
mount --bind /dev /dev/pts
mount --bind /dev /dev/pts/pts
etc. enough times to overflow the kernel stack on recursion.
