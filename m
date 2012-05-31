Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab2EaKMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:12:48 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:56545
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752124Ab2EaKMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:12:46 -0400
Date: Thu, 31 May 2012 12:12:42 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] UBIFS: compute KSA size and store in superblock
In-Reply-To: <1338391121.2536.94.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1205311211340.15137@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205251509220.2989@eristoteles.iwoars.net>  <1337952271.30969.37.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1205301531220.6465@eristoteles.iwoars.net> <1338391121.2536.94.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You need to validate that:
>
> 1. if use_ubifsec is true, then ksa_lebs is not zero.
> 2. ksa_lebs is sane - not too small, not too large.
>

Will add an assert and a dbg check function.


> > diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
> > index 90f348c..1dda25d 100644
> > --- a/fs/ubifs/ubifs-media.h
> > +++ b/fs/ubifs/ubifs-media.h
> > @@ -618,10 +618,13 @@ struct ubifs_pad_node {
> >   * @rp_uid: reserve pool UID
> >   * @rp_gid: reserve pool GID
> >   * @rp_size: size of the reserved pool in bytes
> > - * @padding2: reserved for future, zeroes
>
> Do not remove this comment.
>

I only moved it, new fields were added to the struct and it was not longer
in the correct place in the comment.

> >   * @time_gran: time granularity in nanoseconds
> >   * @uuid: UUID generated when the file system image was created
> >   * @ro_compat_version: UBIFS R/O compatibility version
> > + * @crypto_lebs: number of LEBS being used to store keys
> > + * @use_ubifsec: the LSB signifies whether the file system should use secure
> > + *		 deletion
> > + * @padding2: reserved for future, zeroes
> >   */


Cheers,
Joel Reardon
