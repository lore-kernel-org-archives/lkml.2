Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2HPTKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:10:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50020 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2HPTK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:10:28 -0400
Message-ID: <1345144127.3402.2.camel@falcor.watson.ibm.com>
Subject: Re: [RFC v2 2/7] keys: initialize root uid and session keyrings
 early
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Date: Thu, 16 Aug 2012 15:08:47 -0400
In-Reply-To: <CA+5PVA71WegBSBbgZDBZopORkAMN9G8i2MXHmAGdpiSjWzo9RQ@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	 <ec8635c36005ba5ea3784276214fb905720ee3ec.1345055639.git.dmitry.kasatkin@intel.com>
	 <CA+5PVA71WegBSBbgZDBZopORkAMN9G8i2MXHmAGdpiSjWzo9RQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081619-5806-0000-0000-00001877DE95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 14:26 -0400, Josh Boyer wrote:
> On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
> > From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >
> > In order to create the integrity keyrings (eg. _evm, _ima, _modules),
> > root's uid and session keyrings need to be initialized early.
> >
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> >  security/keys/Makefile       |    1 +
> >  security/keys/root_keyring.c |   18 ++++++++++++++++++
> >  2 files changed, 19 insertions(+)
> >  create mode 100644 security/keys/root_keyring.c
> >
> > diff --git a/security/keys/Makefile b/security/keys/Makefile
> > index 504aaa0..c93ce8d 100644
> > --- a/security/keys/Makefile
> > +++ b/security/keys/Makefile
> > @@ -18,6 +18,7 @@ obj-y := \
> >  obj-$(CONFIG_KEYS_COMPAT) += compat.o
> >  obj-$(CONFIG_PROC_FS) += proc.o
> >  obj-$(CONFIG_SYSCTL) += sysctl.o
> > +obj-$(CONFIG_INTEGRITY_SIGNATURE) += root_keyring.o
> >
> >  #
> >  # Key types
> > diff --git a/security/keys/root_keyring.c b/security/keys/root_keyring.c
> > new file mode 100644
> > index 0000000..f6662eb
> > --- /dev/null
> > +++ b/security/keys/root_keyring.c
> > @@ -0,0 +1,18 @@
> > +/*
> > + * Copyright (C) 2012 IBM Corporation
> > + *
> > + * Author:
> > + * Mimi Zohar <zohar@us.ibm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation, version 2 of the License.
> > + */
> > +
> > +#include "internal.h"
> > +static int __init init_root_keyring(void)
> > +{
> > +       return install_user_keyrings();
> > +}
> > +
> > +late_initcall(init_root_keyring);
> > --
> 
> Why is this in an entirely new file instead of just being added to
> process_keys.c ?
> 
> josh

Only when "CONFIG_INTEGRITY_SIGNATURE" is selected, does this get built.

Mimi

