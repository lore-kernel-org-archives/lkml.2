Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0JUT6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:58:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab0JUT6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:58:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in get_property()
Date: Thu, 21 Oct 2010 21:57:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101016141321.GA11054@sucs.org> <201010172032.43206.rjw@sisk.pl> <20101021165420.GA8718@sucs.org>
In-Reply-To: <20101021165420.GA8718@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010212157.47952.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 21, 2010, Sitsofe Wheeler wrote:
> On Sun, Oct 17, 2010 at 08:32:42PM +0200, Rafael J. Wysocki wrote:
> > 
> > Still, if user space has problems with failing reads from the sysfs
> > attributes, it may be better to simply put -1 in there.  Patch is
> > appended, please test.
> 
> This patch does what it says on the tin (returns -1 in sysfs on my EeePC
> 900). So:
> 
> Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> 
> It's a shame the previous changes didn't work as they stopped a buggy
> upower using the -1 value (and producing a nonsense rate like 8.4e-06)

Hmm.  So upower _doesn't_ handle -1?  What does it do with -1000, then?

> but it's not clear which part of the stack can't handle -ENODATA
> perhaps it is another part of the kernel?

I don't really think it's a part of the kernel.

> Richard, any chance of upower being changed to test for -1 before doing
> doing anything with current_now (
> http://cgit.freedesktop.org/DeviceKit/upower/tree/src/linux/up-device-supply.c?id=5387183d53c16a987a0737c1bdec1b62edf3daa6#n561)?
> I guess there are a whole bunch of other attributes that could
> theoretically be -1 and shouldn't be used if they return it...

If user space doesn't handle -1 correctly too, I think the right approach for
us should be to use the previous version of the patch and return error code
for unknown values.

Thanks,
Rafael
