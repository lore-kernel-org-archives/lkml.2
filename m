Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0LLWQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 17:16:47 -0500
Received: from judith.fzi.de ([141.21.4.44]:18358 "EHLO judith.fzi.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0LLWQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 17:16:46 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 17:16:46 EST
Date: Sun, 12 Dec 2010 23:01:28 +0100
From: Florian Mickler <mickler@fzi.de>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] [correction] load fbcon from drm_kms_helper
Message-ID: <20101212230128.47c20b10@schatten.dmk.lab>
In-Reply-To: <20101212183921.GA25744@spacedout.fries.net>
References: <20101212183921.GA25744@spacedout.fries.net>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2010 22:01:31.0411 (UTC) FILETIME=[224EE630:01CB9A48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010 12:39:22 -0600
David Fries <david@fries.net> wrote:

> Kconfig says fbcon is required by drm_kms_helper.  If radeon, fbcon,
> and drm_kms_helper are all modules, radeon is auto loaded (by PCI id?),
> drm_kms_helper is loaded because of the module dependency, but fbcon
> isn't loaded leaving the console unusable.  Since fbcon is required
> and there isn't an explicit module dependency, request the module
> to be loaded from drm_kms_helper.
> 
> Signed-off-by: David Fries <david@fries.net>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> ---
> The last patch had a typo 'namue', mental reminder, test again after
> running checkpatch.pl.
> 
> This solves compiling CONFIG_FB=m and being left with a blank screen
> because the radeon module is automatically loaded, but fbcon isn't.
> If radeon had to be manually loaded, then it would be the user's fault
> for
> not loading fbcon as well, but as radeon is being loaded
> automatically,
> there isn't much a user can do from console to even fix it.  More bug
> details from here,
> https://bugzilla.kernel.org/show_bug.cgi?id=16221

I guess this is reasonable. Maybe _if_ there actually is a usecase for
a drm driver without fbcon, the drm could provide a
parameter to skip loading fbcon?

But also the drm Kconfig seems to be bogus? SELECT is not transitiv. 
So selecting DRM_KMS_HELPER is not enough, as it will not select FB
and FRAMEBUFFER_CONSOLE. Maybe the drm drivers that currently
select DRM_KMS_HELPER should instead depend on it.  

Sincerely,
Flo


