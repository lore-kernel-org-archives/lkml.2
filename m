Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2LLKpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:45:06 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:55242 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2LLKpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:45:03 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJjy0PF1k=
X-RZG-CLASS-ID: mo00
Date: Wed, 12 Dec 2012 11:45:00 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] xen/blkback: prevent repeated
 backend_changed invocations
Message-ID: <20121212104500.GB3382@aepfle.de>
References: <1355259026-16946-1-git-send-email-olaf@aepfle.de>
 <50C85F9F02000078000AFD6E@nat28.tlf.novell.com>
 <1355308476.10554.11.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355308476.10554.11.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21.rev5558 (2012-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, Ian Campbell wrote:

> On Wed, 2012-12-12 at 09:42 +0000, Jan Beulich wrote:
> > >>> On 11.12.12 at 21:50, Olaf Hering <olaf@aepfle.de> wrote:
> > > backend_changed might be called multiple times, which will leak
> > > be->mode. Make sure it will be called only once. Remove some unneeded
> > > checks. Also the be->mode string was leaked, release the memory on
> > > device shutdown.
> > 
> > So did I miss some discussion here? I haven't seen any
> > confirmation of this function indeed being supposed to be called
> > just once.
> > 
> > Also, as said previously, if indeed it is to be called just once,
> > removing the watch during/after the first invocation would seem
> > to be the more appropriate thing to do.
> 
> The watch fires (often needlessly) when you first register it so in the
> common case it is going to be called twice. Of course that first time
> should abort early on so perhaps that's a moot point.

The current code handles that, if a property does not exist the function
will exit early.

Olaf
