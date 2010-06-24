Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0FXBgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 21:36:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51562 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab0FXBgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 21:36:03 -0400
X-Sasl-enc: LrcAkzcC5j+qVh5RNPEyolV/0fDlNsED04Z/aDqyIQJW 1277343360
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
From: Ian Kent <raven@themaw.net>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       vaurora@redhat.com, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, jblunck@suse.de
In-Reply-To: <9219.1277258833@jrobl>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
	 <1276661043.2339.35.camel@localhost> <1277091579.3827.9.camel@localhost>
	 <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu> <1277181999.2829.2.camel@localhost>
	 <26799.1277185756@jrobl> <1277256214.2848.17.camel@localhost>
	 <9219.1277258833@jrobl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 09:35:50 +0800
Message-ID: <1277343350.2841.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 11:07 +0900, J. R. Okajima wrote:
> Ian Kent:
> > I may be missing something about this, but why is it safe to use
> > iterate_mounts(), since it doesn't take the vfsmount_lock when
> > traversing the list of mounts?
> 
> The sample code was not correct.
> We need to acquire vfsmount_lock or down_read(namespace_sem).

This is looking more and more suspect the more I dig.

The only place iterate_mounts() is called is within the audit subsystem
AFAICS, and I don't see where vfsmount_lock is taken in that code. OTOH,
in fs/namespace.c it is pretty clear that vfsmount->mnt_list is
protected by the vfsmount_lock.

Ummm ... that's gota be broken but maybe someone can give a reason why
it isn't?

Ian


