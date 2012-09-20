Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2ITRk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab2ITRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:40:25 -0400
Date: Thu, 20 Sep 2012 13:40:20 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH V2 07/10] Secure boot: Add a dummy kernel parameter that
 will switch on Secure Boot mode
Message-ID: <20120920174020.GG22211@hansolo.jdub.homelinux.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <1348152065-31353-8-git-send-email-mjg@redhat.com>
 <20120920163237.GA11077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920163237.GA11077@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:32:37PM +0100, Greg KH wrote:
> On Thu, Sep 20, 2012 at 10:41:02AM -0400, Matthew Garrett wrote:
> > From: Josh Boyer <jwboyer@redhat.com>
> > 
> > This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and cap_bset
> > in the init_cred struct, which everything else inherits from.  This works on
> > any machine and can be used to develop even if the box doesn't have UEFI.
> > 
> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> > ---
> >  kernel/cred.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/kernel/cred.c b/kernel/cred.c
> > index de728ac..7e6e83f 100644
> > --- a/kernel/cred.c
> > +++ b/kernel/cred.c
> > @@ -623,6 +623,23 @@ void __init cred_init(void)
> >  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> >  }
> >  
> > +void __init secureboot_enable()
> > +{
> > +	pr_info("Secure boot enabled\n");
> > +	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
> > +	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
> > +}
> > +
> > +/* Dummy Secure Boot enable option to fake out UEFI SB=1 */
> > +static int __init secureboot_enable_opt(char *str)
> > +{
> > +	int sb_enable = !!simple_strtol(str, NULL, 0);
> > +	if (sb_enable)
> > +		secureboot_enable();
> > +	return 1;
> > +}
> > +__setup("secureboot_enable=", secureboot_enable_opt);
> 
> Document this please in the bootparams file.

Oops, yes.  Will do.  Thanks for pointing it out.

josh
