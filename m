Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab0FWCSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 22:18:17 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:64009 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0FWCSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 22:18:15 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount in super block info
To: Ian Kent <raven@themaw.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       vaurora@redhat.com, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, jblunck@suse.de
In-Reply-To: <1277256214.2848.17.camel@localhost>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-5-git-send-email-vaurora@redhat.com> <1276661043.2339.35.camel@localhost> <1277091579.3827.9.camel@localhost> <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu> <1277181999.2829.2.camel@localhost> <26799.1277185756@jrobl> <1277256214.2848.17.camel@localhost>
Date: Wed, 23 Jun 2010 11:07:13 +0900
Message-ID: <9219.1277258833@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ian Kent:
> I may be missing something about this, but why is it safe to use
> iterate_mounts(), since it doesn't take the vfsmount_lock when
> traversing the list of mounts?

The sample code was not correct.
We need to acquire vfsmount_lock or down_read(namespace_sem).

Or it may be better to extract the body of iterate_mounts() and create a
new function __iterate_mounts() such like that.

__iterate_mounts()
{
	/* equiv to the current iterate_mounts */
}

iterate_mount()
{
	down_read(namespace_sem);
	or spin_lock(&vfsmount_lock);

	__iterate_mount();

	spin_unlock(&vfsmount_lock);
	or up_read(namespace_sem);
}


J. R. Okajima
