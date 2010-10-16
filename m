Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0JPDHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 23:07:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31728 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0JPDHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 23:07:45 -0400
From: "Koornstra, Reinoud" <koornstra@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>
CC: Sameer Nanda <snanda@chromium.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "brad.figg@canonical.com" <brad.figg@canonical.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 16 Oct 2010 03:03:54 +0000
Subject: RE: [PATCH] ACPI: Read TSC upon resume
Thread-Topic: [PATCH] ACPI: Read TSC upon resume
Thread-Index: ActmaROsvOmUVB4aS4SZqgJve6MbTgGdJfPA
Message-ID: <E92FAF79A8BBC642A36EEE3AA7F152D884DB9CA072@GVW1089EXB.americas.hpqcorp.net>
References: <1286406919-6236-1-git-send-email-snanda@chromium.org>
 <AANLkTik=imw5XRpXSkboyB6txXio6Y65bLV+EdfvRXg3@mail.gmail.com>
 <20101007181536.GA24811@suse.de> <201010072344.22166.rjw@sisk.pl>
In-Reply-To: <201010072344.22166.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Thursday, October 07, 2010 2:44 PM
> To: Greg KH
> Cc: Sameer Nanda; lenb@kernel.org; stefan.bader@canonical.com;
> brad.figg@canonical.com; apw@canonical.com; linux-acpi@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ACPI: Read TSC upon resume
> 
> On Thursday, October 07, 2010, Greg KH wrote:
> > On Thu, Oct 07, 2010 at 11:05:21AM -0700, Sameer Nanda wrote:
> > > On Thu, Oct 7, 2010 at 10:46 AM, Greg KH <gregkh@suse.de> wrote:
> > > > On Thu, Oct 07, 2010 at 10:43:34AM -0700, Sameer Nanda wrote:
> > > >> On Wed, Oct 6, 2010 at 7:19 PM, Greg KH <gregkh@suse.de> wrote:
> > > >> > And are you always going to be printing this out?  Why do we
> want to
> > > >> > know this every time?
> > > >> >
> > > >>
> > > >> Yes, every time.  This helps track variance in BIOS resume times
> within a
> > > >> single boot.
> > > >
> > > > Is that really something that users can do something about?
> > >
> > > Aside from complaining to the BIOS vendors, no :)
> >
> > Then I would not recommend adding this patch, as it is irrelevant for
> > 99.9999% of all Linux users.
> 
> It may be somewhat useful, but the rdtscll() call seems to be x86-
> specific, in
> which case it shouldn't be used at this place.

Also, in the case of an intel core 2 duo cpu, the tsc is not stable, hence upon resume the cpu is spinning up and the first tsc's will be slower.
During idle-time the tsc will not be incremented. The tsc is only stably incremented upon 100% cpu usage. It also doesn't increment faster in turbo mode in case of some core 2 duo and certainly the Nehalem cpu's. Calculating in time in terms of tsc might not be so reliable.

> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
