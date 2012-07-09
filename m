Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2GIWIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:08:17 -0400
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34036 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2GIWIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:08:16 -0400
Date: Tue, 10 Jul 2012 01:08:01 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>,
        arnaud.patard@rtp-net.org, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19 v2] Staging: xgifb: Remove LCDA detection in
 xgifb_probe().
Message-ID: <20120709220801.GA19103@blackmetal.musicnaut.iki.fi>
References: <cover.1341569486.git.magomez@igalia.com>
 <0b5331426e8c4fc37b62c58e052526c8c4a28495.1341569486.git.magomez@igalia.com>
 <20120709183947.GA21153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120709183947.GA21153@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 09, 2012 at 11:39:47AM -0700, Greg KH wrote:
> On Fri, Jul 06, 2012 at 12:40:38PM +0200, Miguel Gómez wrote:
> > The piece of code that checks for LCDA in xgifb_probe() just checks for some
> > register values but doesn't really do anything in response to them (the actions
> > that should be executed are commented).
> > As nothing is really being done, the code can be safely removed.
> 
> Are you sure?  Some devices (foolish ones that is) need registers read
> to work properly as that is part of their start-up logic.  Yeah, it
> doesn't seem to make sense, but hardware designers usually have good
> reasons for doing this type of thing.  Or at least they think they do :)

Those registers (CR 0x30..0x38) are scratch registers, so reading them
should have no side effects in the device side. I think it's safe to
delete that code.

A.
