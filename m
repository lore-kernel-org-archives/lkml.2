Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab2DAIvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:51:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab2DAIvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:51:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Sun, 1 Apr 2012 10:55:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Aaron Lu <aaron.lu@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>,
        "Moore, Robert" <robert.moore@intel.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <201204010947.27234.rjw@sisk.pl> <1333267314.2387.122.camel@rui.sh.intel.com>
In-Reply-To: <1333267314.2387.122.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204011055.39417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 01, 2012, Zhang Rui wrote:
> On 日, 2012-04-01 at 09:47 +0200, Rafael J. Wysocki wrote:
> > On Sunday, April 01, 2012, Aaron Lu wrote:
> > > Hi,
> > > 
> > > On Sun, Apr 01, 2012 at 03:03:39PM +0800, Zhang Rui wrote:
> > > > First of all, I agree that we must evaluate _PS3 when setting device to
> > > > either D3_HOT or D3_COLD.
> > > Good.
> > > 
> > > > 
> > > > And here is my understanding about D3/D3_HOT/D3_COLD,
> > > > 
> > > > if _PR3 exists, it means the devices supports both D3_HOT and D3_COLD.
> > > Agree.
> > > 
> > > > 
> > > > if only _PS3 exists, we can only say that the state after evaluating
> > > > _PS3 is D3, it could either be D3_HOT or D3_COLD, and this is device
> > > > specific, which in your case, is D3_COLD.
> > > I prefer Rafeal's definition, let's just *assume* the device is at D3
> > > cold after its _PS3 is executed. Unless it has _PR3, in which case, we
> > > have a chance to put the device into D3 hot instead.
> > > 
> > > > 
> > > > BTW, here is the description of _S0W in ACPI spec,
> > > > If OSPM has not indicated that it supports _PR3 through the OSPM
> > > > Platform-Wide Capabilities (see Section 6.2.10.2), then the value "3"
> > > > corresponds to D3. If it has indicated _PR3 support, the value "3"
> > > > represents D3hot and the value "4" represents D3cold.
> > > > 
> > > > So IMO, the _S0W should return 3 in AMD's implementation as it does not
> > > > have _PR3.
> > > OK, sounds like a firmware bug.
> > > Thanks for identifying this.
> > 
> > I don't think this is a bug.  It actually may return either 3 or 4, because
> > there is no difference between them if there's no _PR3 (i.e. the action to
> > carry out by software would only be different if _PR3 were present).
> > 
> I mean, surely that software should handle this case.

Well, exactly. :-)

> But this is still a violation of ACPI spec, as the device has only one
> D3 state, instead of D3_HOT/D3_COLD,, thus _S0W should return 3 instead.

If software is expected to handle that case anyway, I wouldn't really call
it a violation.  What really matters is what software is supposed to do.

Thanks,
Rafael
