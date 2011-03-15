Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab1COUUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:20:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758139Ab1COUUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:20:22 -0400
Date: Tue, 15 Mar 2011 13:18:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>, Sage Weil <sage@newdream.net>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "hch@lst.de" <hch@lst.de>, "l@jasper.es" <l@jasper.es>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Message-Id: <20110315131846.4d41af3c.akpm@linux-foundation.org>
In-Reply-To: <C79DDACF-9320-424D-84F5-3DB9C5325B1D@dilger.ca>
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	<edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	<201103111255.44979.arnd@arndb.de>
	<ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	<20110311235607.GB15853@elie>
	<9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
	<20110312021001.GA16833@elie>
	<20110312173217.GA24981@kroah.com>
	<1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
	<Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net>
	<20110315101155.GO15097@dastard>
	<C79DDACF-9320-424D-84F5-3DB9C5325B1D@dilger.ca>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 09:56:08 -0600
Andreas Dilger <adilger@dilger.ca> wrote:

> Should there be a "wait" argument or flag that allows an app to start the syncfs(), do something, and then call again to wait for completion?

I don't think so.  If userspace wants to do that then fork().

> > Perhaps we should consider propagating errors out to the user
> > application rather than discarding them in kernel and pretending we
> > can't ever have a write error?

That would be nice, but is probably a pretty complex thing to
implement.  The manpage should include words indicating that syncfs()
can return an errno.  That way, userspace will hopefully have the
appropriate checks, whcih will become more useful if/when the kernel
implementation gets fixed up.

