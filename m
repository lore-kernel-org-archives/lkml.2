Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2ENRUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:20:52 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:33193
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1757317Ab2ENRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:20:51 -0400
Date: Mon, 14 May 2012 19:20:49 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: add crypto lookup field to tree node cache
In-Reply-To: <1337001716.2528.56.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1205141907290.12448@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205111323010.17715@eristoteles.iwoars.net> <1337001716.2528.56.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The long long is divided as follows:
32 bits for the (KSA-relative) LEB number, 32 bits for the offset in the
leb where the key is found. So its the same as the lnum/offs for the
current one. Theres substancial compression though, that is available,
since theres likely not more than 2^^32 LEBS for the KSA and the number of
bits needed for key offset is LEB_SHIFT - 4.

Is 32 bits sufficient to address all keys:
one key per datanode means 4096 * 2^32 = 2^44, so only 16 TB available
for 32 bit key addresses.

Though there is similar waste for lnum/offs as well. Perhaps zbranches can
be stored as a u8[] and demarshalled with bit-op macros when needed for
computations.

Joel Reardon




On Mon, 14 May 2012, Artem Bityutskiy wrote:

> On Fri, 2012-05-11 at 13:24 +0200, Joel Reardon wrote:
> >  struct ubifs_zbranch {
> >  	union ubifs_key key;
> > @@ -751,6 +752,7 @@ struct ubifs_zbranch {
> >  	int lnum;
> >  	int offs;
> >  	int len;
> > +	long long crypto_lookup;
> >  };
>
> Why is it "long long" which is 64 bit? What will it contain? Could we
> make it unsigned int - we'd waste less RAM then - remember that we
> allocate a lot of these structures.
>
> --
> Best Regards,
> Artem Bityutskiy
>
