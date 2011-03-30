Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1C3MyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:54:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1C3MyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:54:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality in separate module
Date: Wed, 30 Mar 2011 14:53:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rmk+kernel@arm.linux.org.uk,
        devel@linuxdriverproject.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz>
In-Reply-To: <4D91B856.8040302@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301453.48607.arnd@arndb.de>
X-Provags-ID: V02:K0:NIgTUqCgVeZg8ooeP6ty089F4+DxLG+xvcB5HJbZSlm
 eSFXSkrApd6MigMCnz62O+SuBiJL13THk0IDoECutwbic4nSPX
 Z1AzylGCSIRumpD8uUwR3b7aEM6h8JO4rrg6jdgJuJ/vdJIpVc
 YLISNwxGopUemCIZtzbsB7xB0pkxF8KLJbDKmcLhdFMGwE9lVO
 yeZ5ntcw/qIwprZcU4+Ow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011, Jiri Slaby wrote:
> On 03/29/2011 11:40 AM, Arend van Spriel wrote:
> > --- /dev/null
> > +++ b/drivers/brcmaxi/axi.c
> > @@ -0,0 +1,786 @@
> ...
> > +/* resetctrl */
> > +#define	AIRC_RESET		1
> > +
> > +/* definition for specifying padding fields */
> > +#define	_PADLINE(line)	pad ## line
> > +#define	_XSTR(line)	_PADLINE(line)
> > +#define	PAD		_XSTR(__LINE__)
> > +
> > +/*
> > + * struct aidmp - device management plugin "wrapper" registers.
> > + */
> > +struct aidmp {
> 
> This looks like it should be __packed__.

Why that? Adding the packed attribute would enforce byte access but
not change the layout of the structure, so I think that would make
it worse not better.

	Arnd
