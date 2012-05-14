Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2ENSpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:45:46 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:36705
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753955Ab2ENSpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:45:45 -0400
Date: Mon, 14 May 2012 20:45:42 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: add crypto lookup field to tree node cache
In-Reply-To: <1337020106.2042.2.camel@koala>
Message-ID: <alpine.DEB.2.00.1205142032210.12448@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205111323010.17715@eristoteles.iwoars.net>  <1337001716.2528.56.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1205141907290.12448@eristoteles.iwoars.net> <1337020106.2042.2.camel@koala>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use this because I figured it should be abstracted in functions that
have these values, but don't need to know about the internal structure.
>From the view of all UBIFS components (except the new keymap), two values
have no more meaning than one, its all just some value the keymap gives
out and returns the same key on read_key.

cheers,
Joel Reardon

On Mon, 14 May 2012, Artem Bityutskiy wrote:

> On Mon, 2012-05-14 at 19:20 +0200, Joel Reardon wrote:
> > The long long is divided as follows:
> > 32 bits for the (KSA-relative) LEB number, 32 bits for the offset in the
> > leb where the key is found. So its the same as the lnum/offs for the
> > current one. Theres substancial compression though, that is available,
> > since theres likely not more than 2^^32 LEBS for the KSA and the number of
> > bits needed for key offset is LEB_SHIFT - 4.
> >
> > Is 32 bits sufficient to address all keys:
> > one key per datanode means 4096 * 2^32 = 2^44, so only 16 TB available
> > for 32 bit key addresses.
> >
> > Though there is similar waste for lnum/offs as well. Perhaps zbranches can
> > be stored as a u8[] and demarshalled with bit-op macros when needed for
> > computations.
>
> OK, thanks for explanation. Why not to then store 2x32-bit fields
> instead, which is consistent with the current style? Why "long long"?
>
> --
> Best Regards,
> Artem Bityutskiy
>
