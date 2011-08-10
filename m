Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HJOK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:10:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1HJOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:10:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Mark Rutland" <mark.rutland@arm.com>
Subject: Re: Subject: L2x0 OF properties do not include interrupt #
Date: Wed, 10 Aug 2011 16:09:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, weizeng.he@csr.com, workgroup.linux@csr.com,
        "'Barry Song'" <21cnbao@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "Will Deacon" <Will.Deacon@arm.com>
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
In-Reply-To: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108101609.56995.arnd@arndb.de>
X-Provags-ID: V02:K0:1SPGK4HLct06oZEQJy9RC3BUK8UtLvRllz2BU3Xr44P
 B9AanrlAe2yru4CSBeyNf4CUt2Aun3UBxv06mje9eUugtXcKQS
 ZwXw4muEvB9Rx3n+vcQZBZvjQkU3N102HRhAOHd8hQtK5sJ08w
 5mLZg7leEYeJ86dGxPNs6P8bV2nfpkVZWK+6ilUAi6WnkciFiI
 7ZHHTWkkntHCPtkCPxMTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 August 2011, Mark Rutland wrote:

> I realise I'm a bit late to the party here, but I'd like to propose adding an
> optional interrupt parameter to the binding. I'm not aware of any
> implementations which use separate interrupts, but given the binding
> seems to be generic across L2CC implementations (and is not limited simply to
> the L2x0), having a list rather than a single interrupt may be appropriate for
> someone.

Sounds good, thanks for pointing this out.

How many possible interrupt sources are there? If there is only a small number
of those (e.g. at most 4), we might just list all of them and register
them from the driver even if they are all the same.

> This would boil down to (for the moment) a Documentation change along the lines of:
> 
> > diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
> > index f50e021..d4b387b 100644
> > --- a/Documentation/devicetree/bindings/arm/l2cc.txt
> > +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
> > @@ -28,6 +28,7 @@ Optional properties:
> >  - arm,filter-ranges : <start length> Starting address and length of window to
> >    filter. Addresses in the filter window are directed to the M1 port. Other
> >    addresses will go to the M0 port.
> > +- interrupt : A combined interrupt.
> >  
> >  Example:
> >  
> > @@ -39,4 +40,5 @@ L2: cache-controller {
> >          arm,filter-latency = <0x80000000 0x8000000>;
> >          cache-unified;
> >          cache-level = <2>;
> > +        interrupt = <45>;
> >  };
> 
> Any thoughts?

Do we also need to document an interrupt-parent property, or is that implied?

	Arnd
