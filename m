Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2LLKej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:34:39 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:8154 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LLKei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:34:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,265,1355097600"; 
   d="scan'208";a="83263"
Message-ID: <1355308476.10554.11.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/blkback: prevent repeated
 backend_changed invocations
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Date: Wed, 12 Dec 2012 10:34:36 +0000
In-Reply-To: <50C85F9F02000078000AFD6E@nat28.tlf.novell.com>
References: <1355259026-16946-1-git-send-email-olaf@aepfle.de>
	 <50C85F9F02000078000AFD6E@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 09:42 +0000, Jan Beulich wrote:
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

The watch fires (often needlessly) when you first register it so in the
common case it is going to be called twice. Of course that first time
should abort early on so perhaps that's a moot point.

Ian.

