Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0IKVPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 17:15:33 -0400
Received: from n6-vm0.bullet.mail.gq1.yahoo.com ([98.137.26.79]:20289 "HELO
	n6-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752434Ab0IKVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 17:15:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 831983.78325.bm@omp120.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=N43N+P4TWPoficxi7Z5JQUNjBmggHShrB9qBktaVcqzx4N5n8DT0RIolVBGL0GwwjbPIIaVvUKEl8anwrKSbOkqPOC9l65yZ6xMk6O6Nw6v9C4bNxSzKlhCNVcpQyDy0iBMez0cZt7c0qDEPUDfyQloJhanut9MCJj8iuGeZTVE=;
Message-ID: <749423.9282.qm@web180313.mail.gq1.yahoo.com>
X-YMail-OSG: Xv0W_McVM1k_ASX5nHAL2g6yaEEaa5GzLixnia03A_nxdif
 6UO7divoW6H_8nYS17gFjgXGEHIC05HB3zhVyA2f8SjWkaPbj44h7BXagap8
 JWLaaqXyH8vZcDOtrdU_PeirZ_uNHjAp87JD50IVViZo3FYpqi1gbZRdufgz
 AjtRtucf5SAI7bcneP73HOar2HYj.kEd2Ke5tDRGRL7b77Tz3sXkW3dF15M1
 P1ZOYtj.xsbaMo75tRce6w_GrFvdanH0g0VRUs5gvYCcaccL8omHkAd27n2w
 8rAFaykW4PMNDnnKpOQ--
X-Mailer: YahooMailClassic/11.4.7 YahooMailWebService/0.8.105.279950
Date: Sat, 11 Sep 2010 14:15:29 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] usbnet: do not count empty skbs as errors in rx_process()
To: Ondrej Zary <linux@rainbow-software.org>
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <201009112222.06149.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 9/11/10, Ondrej Zary wrote:

> Date: Saturday, September 11, 2010, 1:22 PM
> On Saturday 11 September 2010
> 21:07:59 David Brownell wrote:
> 
> > NAK to this backwards-incompatible change.
> >
> > >
> > > This is needed for cx82310_eth.

Backwards-incompatible changes are NOT "needed"
> >
> > I'd far rather see that driver fixed, than see
> > the core usbnet framework broken to avoid such
> > fixes to a very new driver ...
> 
> I already tried to explain that the driver is not broken

Yet you keep saying it doesn't work right, which
is the classic definition of "broken, needs fix".


> and so it cannot be 
> fixed. It's the way the hardware works and usbnet
> is not > ready for it.

And when we went over this before, I said how
to resolve this:   a *BACKWARD-COMPATIBLE change
that adds a new return state to rx_fixup(), used
in the cx82310 code.  Why didn't you try that?

This proposed patch doesn't do it, since it punts
on backwards compatibility ... which is a HUGE issue
when we can't easily test all the permutations.
Best to not risk breaking things; and in this case
there's not even any need to take such risks.

- Dave


