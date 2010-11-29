Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0K2URk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:17:40 -0500
Received: from tex.lwn.net ([70.33.254.29]:59746 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0K2URj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:17:39 -0500
Date: Mon, 29 Nov 2010 13:17:37 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
Message-ID: <20101129131737.3dd6eb03@bike.lwn.net>
In-Reply-To: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 20:43:28 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> When two drivers interoperate without an explicit dependency, it is often
> required to prevent one of them from being unloaded safely by dereferencing
> dev->driver->owner. This patch provides a generic function to do this in a
> race-free way.

I must ask: why not, instead, make the dependency explicit?  In
particular, this looks like an application for the proposed media
controller code, which is meant to model the connections between otherwise
independent devices.  The fact that your example comes from V4L2 (which is
the current domain of the media controller) also argues that way.

jon
