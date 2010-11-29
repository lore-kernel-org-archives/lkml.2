Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0K2W2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:28:41 -0500
Received: from tex.lwn.net ([70.33.254.29]:45363 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0K2W2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:28:40 -0500
Date: Mon, 29 Nov 2010 15:28:38 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
Message-ID: <20101129152838.4ff57277@bike.lwn.net>
In-Reply-To: <Pine.LNX.4.64.1011292300300.27962@axis700.grange>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
	<20101129131737.3dd6eb03@bike.lwn.net>
	<Pine.LNX.4.64.1011292147540.27962@axis700.grange>
	<20101129214128.GA9691@kroah.com>
	<Pine.LNX.4.64.1011292300300.27962@axis700.grange>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 23:10:50 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> In my case I have two platform devices: CEU and CSI2. In some cases (with 
> parallel sensors) CEU operates on its own. With serial (CSI-2) camera 
> sensors we need the CSI2 driver. So, I want to 
> try_module_get(csi2_dev->driver->owner) the CSI2 driver from my CEU 
> driver. This call can Oops if not done safely. Am I missing something? Is 
> there an easier way to achieve the same?

This looks exactly like what the V4L2 subdev mechanism was meant to do.
Is there a reason you can't use that interface?

Thanks,

jon
