Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2F1PPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:15:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2F1PPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:15:32 -0400
Date: Thu, 28 Jun 2012 10:15:28 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arun Raghavan <arun.raghavan@collabora.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apple-gmux: Correctly depend on apple_bl for building
Message-ID: <20120628151528.GD15308@thinkpad-t410>
Mail-Followup-To: Arun Raghavan <arun.raghavan@collabora.co.uk>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1340879796-30262-1-git-send-email-arun.raghavan@collabora.co.uk>
 <20120628132058.GA15308@thinkpad-t410>
 <1340889815.4994.4.camel@localhost>
 <20120628134806.GB15308@thinkpad-t410>
 <1340891471.4994.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340891471.4994.10.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 07:21:11PM +0530, Arun Raghavan wrote:
> I missed the stubs, so the patch should probably just be adding this
> line:
> 
> depends on APPLE_BACKLIGHT = n || APPLE_BACKLIGHT
> 
> but that conflicts with the 'select BACKLIGHT_CLASS_DEVICE' (a recursive
> dependency is detected).

Sigh. We have a similar situation with acpi_video, which undoubtedly
also affects some other drivers as well.

This is the best I've been able to come up with.

   depends on BACKLIGHT_CLASS_DEVICE
   depends on BACKLIGHT_APPLE=n || BACKLIGHT_APPLE
   depends on ACPI_VIDEO=n || ACPI_VIDEO

This at least keeps it from being built-in if it's going to be linking
against symbols provided by a module. I'm definitely open to other
suggestions though.

Seth

