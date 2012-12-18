Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2LRPHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:07:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab2LRPHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:07:18 -0500
Date: Tue, 18 Dec 2012 10:07:02 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
Message-ID: <20121218100702.478fc1b1@tlielax.poochiereds.net>
In-Reply-To: <20121218144452.GB31255@liondog.tnic>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
	<CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
	<20121218071317.01cbc41b@tlielax.poochiereds.net>
	<20121218144452.GB31255@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 15:44:52 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Dec 18, 2012 at 07:13:17AM -0500, Jeff Layton wrote:
> > I agree that we often need cifsFYI debug info in order to troubleshoot
> > problems. The question here though is whether compiling those in ought
> > to be the default.
> >
> > In generic distro kernels, I think we do want that turned on even in
> > non-debug kernels. On an embedded arch, it's less compelling.
> >
> > Might it make sense to couple this change with a change to the
> > CONFIG_CIFS_DEBUG help text? Something like:
> >
> > "This option defaults to 'N', but enabling this is strongly encouraged
> > unless memory is severely constrained."
> 
> ... or we make it default n if EMBEDDED, otherwise default y + changing
> the help text?
> 
> > Then we can just try to make sure non-embedded distros enable it.
> 
> Yeah, I don't think distros look at the help text... or?
> 

Yeah, not many do, but presumably they'll set it once and forget about
it. Once someone straightens them out, they should rarely break.

OTOH, the value of defaulting to "N" is pretty low here. Maybe it would
just be best to just drop this patch and have the embedded folks turn
this off on their own.

-- 
Jeff Layton <jlayton@redhat.com>
