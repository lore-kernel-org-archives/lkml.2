Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2F1NsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:48:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33529 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2F1NsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:48:09 -0400
Date: Thu, 28 Jun 2012 08:48:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arun Raghavan <arun.raghavan@collabora.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apple-gmux: Correctly depend on apple_bl for building
Message-ID: <20120628134806.GB15308@thinkpad-t410>
Mail-Followup-To: Arun Raghavan <arun.raghavan@collabora.co.uk>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1340879796-30262-1-git-send-email-arun.raghavan@collabora.co.uk>
 <20120628132058.GA15308@thinkpad-t410>
 <1340889815.4994.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340889815.4994.4.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 06:53:35PM +0530, Arun Raghavan wrote:
> On Thu, 2012-06-28 at 08:20 -0500, Seth Forshee wrote:
> > On Thu, Jun 28, 2012 at 04:06:36PM +0530, Arun Raghavan wrote:
> > > apple_bl_register/unregister() are unconditionally used now, so we need
> > > to make sure that apple_bl is selected appropriately (built-in/module)
> > > if apple-gmux is being built.
> > 
> > apple_bl.h provides stubs for these functions when apple_bl is not
> > built, so this shouldn't be necessary. Are you encoutering a situation
> > that causes build problems?
> 
> Yes, I am. With CONFIG_BACKLIGHT_APPLE=m and CONFIG_APPLE_GMUX=y, I see
> the following error:
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `gmux_probe':
> apple-gmux.c:(.devinit.text+0xa769): undefined reference to `apple_bl_unregister'
> drivers/built-in.o: In function `gmux_remove':
> apple-gmux.c:(.devexit.text+0x46d): undefined reference to `apple_bl_register'

Yuck. In that case I don't think your patch probably goes far enough to
fix your situation.

As far as I know select isn't recursive, i.e. it won't select the
dependencies of the thing you select. 
