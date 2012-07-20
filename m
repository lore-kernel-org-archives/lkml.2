Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2GTRxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:53:12 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:35732 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:53:11 -0400
Subject: Re: linux-next: manual merge of the staging tree with the
 target-merge tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
In-Reply-To: <20120719235523.GA13623@kroah.com>
References: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
	 <20120719235523.GA13623@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jul 2012 10:52:58 -0700
Message-ID: <1342806778.25472.1.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, 2012-07-19 at 16:55 -0700, Greg KH wrote:
> On Thu, Jul 19, 2012 at 02:53:01PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/Kconfig between commit d0146d396bfa ("tcm_vhost: Initial
> > merge for vhost level target fabric driver") from the target-merge tree
> > and commit 15a4bc17b7f4 ("Staging: add CSR Wifi "os helper" module") from
> > the staging tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc drivers/staging/Kconfig
> > index 67ec9fe,e3402d5..0000000
> > --- a/drivers/staging/Kconfig
> > +++ b/drivers/staging/Kconfig
> > @@@ -132,6 -132,8 +132,10 @@@ source "drivers/staging/ipack/Kconfig
> >   
> >   source "drivers/staging/gdm72xx/Kconfig"
> >   
> > + source "drivers/staging/csr/Kconfig"
> > + 
> > + source "drivers/staging/omap-thermal/Kconfig"
> > + 
> >  +source "drivers/vhost/Kconfig.tcm"
> 
> Why is someone putting a non drivers/staging/ Kconfig file here in
> drivers/staging/Kconfig?  That's not ok at all.
> 
> Target people, please just depend on CONFIG_STAGING if you want to do
> that, but don't mess with files in the drivers/staging/ directory for no
> good reason at all.
> 

This was a request from MST (CC'ed) in order to have TCM_VHOST show up
under the staging configuration options..

If that's really not what should be done, I'm happy to drop this part
and just use CONFIG_STAGING again.

MST, is that OK..?

Thanks,

--nab

