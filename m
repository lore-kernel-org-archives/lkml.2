Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2HTUnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:43:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab2HTUnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:43:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andre Przywara <andre.przywara@amd.com>
Subject: Re: [PATCH 7/8] cpufreq: Remove support for hardware P-state chips from powernow-k8
Date: Mon, 20 Aug 2012 22:49:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: cpufreq@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com> <201208052333.15608.rjw@sisk.pl> <503234FA.908@amd.com>
In-Reply-To: <503234FA.908@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208202249.16445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 20, 2012, Andre Przywara wrote:
> On 08/05/2012 11:33 PM, Rafael J. Wysocki wrote:
> > On Thursday, July 26, 2012, Andre Przywara wrote:
> >> From: Matthew Garrett <mjg@redhat.com>
> >>
> >> These chips are now supported by acpi-cpufreq, so we can delete all the
> >> code handling them.
> >>
> >> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> >> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> >
> > Would it be very wrong/confusing to keep that support in the powernow-k8
> > driver for the time being, perhaps making it print a message that the ACPI
> > driver is recommended for those chips?
> 
> Why would you like to do this? Are you concerned about regressions?

Yes.  Suppose you have a system configured to use the powernow-k8 driver
right now and you find that it stopped working due to a kernel update.
You would be quite upset I suppose.

> Or do you just want to avoid the introduction of the doomed "cpb" feature 
> in acpi-cpufreq?
> 
> I am not sure if keeping support in powernow-k8 would just make people 
> use it still in the future. At least if it would just load easily as before.
> One idea could be to keep the code around, but only load on family 10h 
> if a force_fam10h or so command line option is provided. But again this 
> could just push distributions to provide this option to avoid the 
> transition.

We don't force transitions like that, mind you.

> One of my motivations was to keep only _one_ driver around, the code 
> removal of the fam10h support from powernow-k8 supports this.
> 
> If you insist, I can keep the code in powernow-k8, but it probably 
> wouldn't receive any support anymore and would increase confusion on the 
> user side.

I'm not afraid of that.  And as I said, you can just add info messages to
powernow-k8 saying that the feature is deprecated and will be removed in the
future and _then_ you actually _can_ remove it in the future (say, 2-3 major
kernel releasew from now).

Thanks,
Rafael
