Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab1COQun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:50:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab1COQum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:50:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device driver into misc
Date: Tue, 15 Mar 2011 17:50:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <201103151429.29460.arnd@arndb.de> <4D7F7C04.50909@cam.ac.uk>
In-Reply-To: <4D7F7C04.50909@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151750.33179.arnd@arndb.de>
X-Provags-ID: V02:K0:1aaEf1mGCeE60FRPdv50LgnVsKZ2SNkMTeUlMV29v3H
 9yI8X1aH6weLB2ekyfYMUi0afePlLnZJcHhKhpyqdCxpd2v6bJ
 D6m9vB+E314wuYbwAhP26qG2IP+jfO60xH3V/f6GNvHeOrSRrJ
 VOas2CU0D003ZRMcO6JWHDhuDQMv0ozh+4d1lFRFAH2Ush74tj
 BagzQwwfD2OdMlIM+i+zg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011, Jonathan Cameron wrote:
> On 03/15/11 13:29, Arnd Bergmann wrote:
> > On Tuesday 15 March 2011, Jonathan Cameron wrote:
> >> An interesting idea though I'm not entirely sure how it would
> >> work in practice.
> >> Two options occurred whilst cycling in this morning.
> >> 1) Spit functionality out in staging. This would give a core
> >> set that is basically the sysfs only stuff.  To do that we'd
> >> have to define a struct iio_dev_basic and make it an element
> >> of the iio_dev.  Prior to that we'd probably need to make pretty
> >> much all accesses into iio_dev via macros / inline functions 
> >> which would not be a trivial undertaking.
> > 
> > I think if you try to maintain compatibility between the
> > basic drivers and the complex stuff in the same tree, you
> > won't be able to gain much. Any major changes to address the TODO
> > items would still potentially impact all drivers.
>
> True though the todo's I know about shouldn't cause trouble for
> the simple drivers.

Ok. If that's the case, it may be simpler to just get the
core into shape for merging, and then do one driver at a
time, but leave all other drivers in staging.

However, without having looked at the code, I would still
assume that it's not that easy and you will actually break
drivers by fixing the core.

> >> That would leave the ugly drivers in staging to pull over
> >> as they get fixed up.
> > 
> > Yes. Or, with my variant, leave a copy of the core as well.
>
> Sure, depending on what is left there.  If we have moved all of the
> above across then there the non staging version should do everything
> the staging version does..

Yes. If they still have a compatible in-kernel API.
 
> > Then leave the complex drivers until you have the infrastructure
> > for them in the new core version.
> Then the key thing is going to be convincing people that there is
> a reason for a lot of what will go in early on, but they'll need to
> look at staging to see why... I guess the version going into mainline
> may need a lot of comments in the code.  Note for some whole classes
> of devices there are only 'complex' drivers.

Well, all the code is in the kernel in the staging drivers, so
any reviewer can look there to see how it's used. You can always
point to a specific driver in the changelog as an example when
a core component gets posted for review in order to have it
in the mainline tree.

	Arnd
