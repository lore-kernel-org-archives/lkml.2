Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0KXIbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:31:14 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48751 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0KXIbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:31:12 -0500
Date: Wed, 24 Nov 2010 17:30:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Bird <tim.bird@am.sony.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 04/16 v4] pramfs: file operations
Message-ID: <20101124083024.GE2212@linux-sh.org>
References: <4CE79BD0.3030200@gmail.com> <20101124075818.GB2212@linux-sh.org> <AANLkTinF2NX9e7deTvDa8zQ0PA4u0ch0xrNWk0FaqvGV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinF2NX9e7deTvDa8zQ0PA4u0ch0xrNWk0FaqvGV@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:11:13AM +0100, Marco Stornelli wrote:
> 2010/11/24 Paul Mundt <lethal@linux-sh.org>:
> > most of this from ext2, I'm curious why you opted to hardcode this
> > instead of maintaining the flexibility that ext2 XIP has over this.
> 
> First of all because it was simpler :) In addition there was some
> design problem to use it in combination with the memory protection.

Do you have more details on this? You can easily check for unsupportable
configurations with mount options and bail out accordingly.

> The difference with ext2 is that we aren't talking about a general
> purpose fs used (mainly) on normal desktop/server systems, but a
> specific fs for embedded world, so I think some little constraints are
> ok.
> 
I'm not sure what your point is. It's not a general purpose file system,
but that's not an excuse for taking shortcuts. Out of the boards on my
desk, I have at least 3 that could make use of this file system where I
could use both XIP and non-XIP for different stores out of the box. I
wouldn't exactly call it a corner case. Also, as Tony's patch set
demonstrates, these sorts of non-volatile data stores are common enough
in the server space to make pramfs an option there, too. Please lose this
mentality that because something was originally tasked for embedded it's
perfectly acceptable to ship a crippled interface.

As it is, this is something that will have to be rewritten one way or the
other, but whether that happens in or out of staging/ is not such a big
concern.
