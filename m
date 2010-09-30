Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab0I3Pdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:33:36 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:7550 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab0I3Pdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:33:35 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
Date: Thu, 30 Sep 2010 09:32:33 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
References: <20100928211246.GA20941@lixom.net> <20100929145330.GA9351@lixom.net> <20100929171118.1dbf3fbb@endymion.delvare>
In-Reply-To: <20100929171118.1dbf3fbb@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009300932.34827.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 29, 2010 09:11:18 am Jean Delvare wrote:
> On Wed, 29 Sep 2010 09:53:30 -0500, Olof Johansson wrote:
> > On Wed, Sep 29, 2010 at 09:34:03AM +0200, Jean Delvare wrote:
> > > Hi Olaf,
> > > 
> > > On Tue, 28 Sep 2010 16:12:46 -0500, Olof Johansson wrote:
> > > > I've found this quite useful since it allows dmidecode to run without
> > > > root privileges using --from-dump to read this file instead
> > > 
> > > This is a bad idea. We do NOT want every user to have access to all the
> > > DMI information. There is sensitive information in there (serial
> > > numbers and UUIDs, and possibly even more sensitive data in
> > > OEM-specific records.)

If DMI has sensitive information, then I agree, we shouldn't expose
the whole table to non-root users.  I don't know the original motivation
for allowing non-root access for dmidecode -- maybe it could be addressed
by making dmidecode smart enough to look at /sys/class/dmi/id/* when
running as a non-root user?

> > It's
> > still better than having a userspace tool dig around /dev/mem for the
> > information.

I don't like /dev/mem either.  If someone's making an effort to remove
/dev/mem, this might be one piece.  But I don't know whether that's
feasible.

> Now if you really insist on exposing the whole DMI table through sysfs,
> I can't prevent you from doing that. After all, ACPI already exposes
> its tables under /sys/firmware/acpi/tables (mode 0400). But then you'd
> rather expose the DMI entry point and tables
> under /sys/firmware/dmi/tables for consistency, rather than using
> debugfs.

If you do pursue this on the grounds of migrating away from /dev/mem,
I like the idea of making it similar to what ACPI does.

Bjorn
