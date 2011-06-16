Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab1FPJAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:00:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab1FPJAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:00:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
Date: Thu, 16 Jun 2011 11:00:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com> <4DF950EB.7050400@intel.com> <20110616013812.GA32494@srcf.ucam.org>
In-Reply-To: <20110616013812.GA32494@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161100.55165.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 16, 2011, Matthew Garrett wrote:
> On Thu, Jun 16, 2011 at 08:40:11AM +0800, Huang Ying wrote:
> > On 06/15/2011 08:17 PM, Matthew Garrett wrote:
> > >> You means the "APEI Support" bit for standard UUID?  Do you know which
> > >> machine uses this bit?  I can write the code, but I have no machine to
> > >> test it.
> > > 
> > > I have access to a Dell system that uses this.
> > 
> > Great! Can you help us to test the code?
> 
> Yup, no problem.
> 
> > > Urgh. One machine I've looked at enables APEI if the WHEA _OSC call is 
> > > made, and then clears a flag if any other _OSC call is made. In that 
> > > specific case it doesn't seem to matter (the flag never actually gets 
> > > checked in any of the other codepaths), but it seems that the intention 
> > > is for the generic call to be made and the WHEA one to be made after 
> > > that.
> > 
> > Yes.  The WHEA call should be made after the generic one.  Another
> > situation is as follow:
> > 
> > - Generic _OSC call without "APEI Support" bit is called (in
> > acpi_bus_osc_support).
> > 
> > - After some time, when we think it is good to turn on firmware first
> > mode fully, usually after we checking HEST and initializing
> > corresponding module, we make generic _OSC call with "APEI Support" bit
> > to turn on firmware first mode fully in standard way.
> > 
> > Is it a good idea to make generic _OSC call twice, one without "APEI
> > Support" bit, the other with "APEI Support" bit?
> 
> I think we probably need to make the HEST decision early, and use that 
> to decide how to make the generic call. Our experience has been that 
> many firmware vendors only expect _OSC to be called once with any given 
> UUID - multiple calls can result in unexpected behaviour.

Not really, as long as the "query enable" bit is set.

Thanks,
Rafael
