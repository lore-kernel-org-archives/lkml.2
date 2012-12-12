Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2LLJry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:47:54 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:32069 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2LLJrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:47:52 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJjy0PF1k=
X-RZG-CLASS-ID: mo00
Date: Wed, 12 Dec 2012 10:47:49 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: prevent repeated backend_changed invocations
Message-ID: <20121212094749.GA3382@aepfle.de>
References: <1355259026-16946-1-git-send-email-olaf@aepfle.de>
 <50C85F9F02000078000AFD6E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C85F9F02000078000AFD6E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5558 (2012-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, Jan Beulich wrote:

> >>> On 11.12.12 at 21:50, Olaf Hering <olaf@aepfle.de> wrote:
> > backend_changed might be called multiple times, which will leak
> > be->mode. Make sure it will be called only once. Remove some unneeded
> > checks. Also the be->mode string was leaked, release the memory on
> > device shutdown.
> 
> So did I miss some discussion here? I haven't seen any
> confirmation of this function indeed being supposed to be called
> just once.
> 
> Also, as said previously, if indeed it is to be called just once,
> removing the watch during/after the first invocation would seem
> to be the more appropriate thing to do.

Does the API allow this, that the called function can disable the watch?

Olaf
