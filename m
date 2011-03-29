Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1C2Mak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:30:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49898 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1C2Maj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:30:39 -0400
Date: Tue, 29 Mar 2011 08:30:35 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: TPM chip prevents machine from suspending
Message-ID: <20110329083035.691731f1@tlielax.poochiereds.net>
In-Reply-To: <4D91CF9D.3050500@linux.vnet.ibm.com>
References: <20110328100846.0ba2e039@tlielax.poochiereds.net>
	<4D90C472.3090908@linux.vnet.ibm.com>
	<20110328141241.06a435f8@tlielax.poochiereds.net>
	<20110328154543.1bb979fd@tlielax.poochiereds.net>
	<4D91157F.2020502@linux.vnet.ibm.com>
	<20110329080856.1726dfaa@tlielax.poochiereds.net>
	<4D91CF9D.3050500@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 08:25:01 -0400
Stefan Berger <stefanb@linux.vnet.ibm.com> wrote:

> >> Another possibility would be for you to check for BIOS updates from the
> >> laptop manufacturer...
> >>
> > This is actually a desktop machine and the BIOS for the motherboard is
> > at the latest version, though it is quite old -- 2007/09/01. For the
> > record this is a:
> >
> >       Foxconn 6150BK8MC
> >
> > I'm actually not using the TPM in this thing at all. I'd be just as
> > happy if there were some way to disable it. Unfortunately, the option
> > in the BIOS to do this doesn't seem to actually work. When I set "TPM
> > Control" in the BIOS to "Disable" it always ends up reset back to "No
> > Change". I'd report both problems to the mfr, but this thing is long
> > out of warranty and I'm pretty sure they won't care.
> >
> > Is there some way short of recompiling with CONFIG_TCG_* turned off
> > to disable the TPM driver at boot time?
> >
> As far as I know, 'no'. I'd defer it to the maintainers as to how they 
> would want to solve your particular problem... either by using above 
> work-around, which would be more transparent, or actively having to turn 
> the driver off with a command line parameter.
> 

I'm fine with leaving it enabled as long as it doesn't get in the way
of suspend working. The scheme you mention above -- test the chip and
conditionally do a TPM_Startup() seems reasonable to me. Let me know if
you need me to test a patch...

Thanks,
-- 
Jeff Layton <jlayton@poochiereds.net>
