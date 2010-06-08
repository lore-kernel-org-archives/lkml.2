Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0FHNWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:22:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17127 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0FHNV7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Jun 2010 09:21:59 -0400
Date: Tue, 8 Jun 2010 09:21:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Robert Emanuele <rob@emanuele.us>
Cc: linux-kernel@vger.kernel.org, jayakumar.lkml@gmail.com
Subject: Re: broadsheetfb and fbcon
Message-ID: <20100608132144.GA4775@phenom.dumpdata.com>
References: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com> <20100607162817.GA13468@phenom.dumpdata.com> <AANLkTim1KloQ4qZTsqHmt2U33dUjM-DDr9-dpooXTx52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim1KloQ4qZTsqHmt2U33dUjM-DDr9-dpooXTx52@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4C0E43F3.0050:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 10:19:27AM -0700, Robert Emanuele wrote:
> There are no module parameters for fbcon or broadsheetfb.
> 
> On Mon, Jun 7, 2010 at 9:28 AM, Konrad Rzeszutek Wilk
> >> Are those kind of updates a limit of the broadsheet driver or fbcon?
> >
> > I thought there was an update value on how often it should redraw. Did
> > you do a modinfo on the driver?

Please do not post your response on top.

What I was thinking about is the delay variable:

1056 static struct fb_deferred_io broadsheetfb_defio = {
1057         .delay          = HZ/4,
1058         .deferred_io    = broadsheetfb_dpy_deferred_io,
1059 };
1060 


Try changing that to a higher number and seeing if that fixes your
problem. If so, you and I can work on a patch that sets a parameter
for this.

