Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0IBNym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:54:42 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42381 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0IBNyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:54:40 -0400
Date: Thu, 2 Sep 2010 15:54:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: gerg@snapgear.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select
	m68knommu contributions
Message-ID: <20100902135438.GA23729@merkur.ravnborg.org>
References: <19747.1283422807@redhat.com> <20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:21:58AM +0100, David Howells wrote:
> Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as nothing in
> the arch defines __uClinux__ for the build.
> 
> This patch was achieved by running the following three commands:
> 
> perl -pi -e 's/ifdef __uClinux__/ifndef CONFIG_MMU/' `find arch/m68k -name "*.[ch]"`
> perl -pi -e 's/ifndef __uClinux__/ifdef CONFIG_MMU/' `find arch/m68k -name "*.[ch]"`
> perl -pi -e 's!endif /[*] __uClinux__ [*]/!endif /* CONFIG_MMU */!' `find arch/m68k -name "*.[ch]"

Have you verified that this does not leak out
to the userspace headers?
We cannot use the CONFIG_ symbol to distingush between
the two variants in userspace.

This was exactly the reason why __uClinux__ was used
in the first place. But I hope Geert/Greg has fixed
it up so all exported headers are the same so that
this patch is OK.

At first look I think it is OK - but your changelog
does not address this so wanted you to confirm this.

	Sam
