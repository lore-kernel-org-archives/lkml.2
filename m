Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2LRMNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:13:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab2LRMNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:13:37 -0500
Date: Tue, 18 Dec 2012 07:13:17 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
Message-ID: <20121218071317.01cbc41b@tlielax.poochiereds.net>
In-Reply-To: <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
	<CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 09:30:33 -0600
Steve French <smfrench@gmail.com> wrote:

> I don't think taking out debugging makes sense - we need debugging a
> lot more often than expected even to diagnose user errors (usually
> relating to session establishment failures, since we are very limited
> in how much information can be passed back in mount).   If we had
> dynamic trace points for cifs and for common vfs entry points, or if
> the distros shipped dual cifs modules (one with debugging and one
> without), I wouldn't mind disabling it - but multiple times a month we
> have to diagnose user problems (sometimes user errors, sometimes
> server bugs etc.) by enabling debugging.
> 
> On Mon, Dec 17, 2012 at 3:38 AM, Borislav Petkov <bp@alien8.de> wrote:
> > Debugging code is generally disabled in the configurator since it is
> > only for devs and testers and not for the majority of the installations.
> >
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Jeff Layton <jlayton@redhat.com>
> > Cc: Steve French <sfrench@samba.org>
> > Cc: linux-cifs@vger.kernel.org
> > Signed-off-by: Borislav Petkov <bp@alien8.de>
> > ---
> >  fs/cifs/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> > index 21ff76c22a17..241a0e2853c5 100644
> > --- a/fs/cifs/Kconfig
> > +++ b/fs/cifs/Kconfig
> > @@ -124,7 +124,6 @@ config CIFS_ACL
> >
> >  config CIFS_DEBUG
> >         bool "Enable CIFS debugging routines"
> > -       default y
> >         depends on CIFS
> >         help
> >            Enabling this option adds helpful debugging messages to
> > --
> > 1.8.1.rc2
> >

I agree that we often need cifsFYI debug info in order to troubleshoot
problems. The question here though is whether compiling those in ought
to be the default.

In generic distro kernels, I think we do want that turned on even in
non-debug kernels. On an embedded arch, it's less compelling.

Might it make sense to couple this change with a change to the
CONFIG_CIFS_DEBUG help text? Something like:

"This option defaults to 'N', but enabling this is strongly encouraged
unless memory is severely constrained."

Then we can just try to make sure non-embedded distros enable it.
-- 
Jeff Layton <jlayton@redhat.com>
