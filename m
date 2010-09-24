Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0IXO3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 10:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0IXO3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 10:29:40 -0400
Date: Fri, 24 Sep 2010 10:29:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic constants
Message-ID: <20100924142927.GA18363@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <20100921214847.GF26290@redhat.com>
 <b151e9f1ec3a162781b380e026f90711.squirrel@www.firstfloor.org>
 <20100922160705.GK26290@redhat.com>
 <AANLkTi=gYa5aEhrQAgpgfopoyW_1v0TJsnQ7bSbTV52i@mail.gmail.com>
 <20100923141651.GL26290@redhat.com>
 <AANLkTi=7kG+PGrQFkWETBSu37SPYxXeXNihB2eBFc6sG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=7kG+PGrQFkWETBSu37SPYxXeXNihB2eBFc6sG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 07:50:16PM +0800, huang ying wrote:
> On Thu, Sep 23, 2010 at 10:16 PM, Don Zickus <dzickus@redhat.com> wrote:
> >> On some system, there is some hardware error log in BMC/BIOS. The
> >> hardware error log can be gotten via IPMI or BIOS menu. Otherwise, can
> >> we get some useful info for unknown NMI? If we can, can we collect the
> >> info, then print it on console and save it into flash via ERST (part
> >> of APEI too) before panic?
> >
> > Ok.  Does the BIOS/BMC automatically do this?  Can we just print a message
> > on panic saying checking your BIOS/BMC logs for more info?
> 
> Yes. BIOS/BMC automatically do that. And I will add it to panic message.
> 
> > I would love to add code to gather more useful info for unknown NMIs, but
> > is it expected that HEST does some of this?  I guess what I am trying to
> > figure out, if we are going to put intelligence to detect a HEST enabled
> > machine and panic when unknown NMI comes along (presumably from HEST??),
> > then can we leverage HEST at all to understand why the NMI happened or
> > point the user to the BIOS/BMC to get more info.  In other words, what
> > value do we get HEST other than we detect its there, lets panic.
> 
> Yes. HEST can be used to report some hardware error information. I am
> working on that now.
> 
> >> HEST is defined in ACPI spec 4.0 and later version in section named
> >> APEI (ACPI Platform Error Interface). It is used to describe the error
> >> sources of system. It should be available only on server platform.
> >
> > Ok.  Does the kernel have intelligence to use it or the BIOS yet?
> 
> HEST works in kernel BIOS cooperative way. I am working on a HEST
> driver which will get notified for NMI and collect the error
> information reported by BIOS. But It is possible that some systems
> have only BMC/BIOS log and do not report that to OS except unknown
> NMI. The unknown NMI panic logic is for these systems.

Ah ok, thanks for the info.  I think adding the info to the panic message
would be valuable.  I have no more objections to your patch now. :-)

I appreciate your patience for clue-ing me in on how HEST works!

Cheers,
Don
