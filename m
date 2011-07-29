Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1G2GK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:10:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58930 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab1G2GK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:10:26 -0400
Date: Fri, 29 Jul 2011 09:08:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jarod Wilson <jarod@redhat.com>,
        Jerome Brock <jbrock@users.sourceforge.net>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gerd Knorr <kraxel@goldbach.in-berlin.de>,
        Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Reitmayr <treitmayr@yahoo.com>,
        Michal Kochanowicz <mkochano@pld.org.pl>,
        Christoph Bartelmus <lirc@bartelmus.de>, Mark Weaver <mark@npsl.co.uk>,
        Ulrich Mueller <ulrich.mueller42@web.de>,
        Stefan Jahn <stefan@lkcc.org>
Subject: Re: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can
 lead to double free
Message-ID: <20110729060822.GF3752@shale.localdomain>
References: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:49:51PM +0200, Jesper Juhl wrote:
> If calling put_ir_rx(rx, true); in
> drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then it
> means that it has freed it's first argument. Subsequently jumping to
> 'out_put_xx' will cause us to call put_ir_rx() once more since 'rx' is
> not zero - leading to a double free.

It would be better to just remove the first call to put_ir_rx().

regards,
dan carpenter

