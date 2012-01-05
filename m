Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2AETnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:43:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34962 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2AETnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:43:43 -0500
Date: Thu, 5 Jan 2012 13:43:38 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] toshiba_acpi: Support alternate hotkey interfaces
Message-ID: <20120105194338.GD25386@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-3-git-send-email-seth.forshee@canonical.com>
 <20120105182522.GD24242@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105182522.GD24242@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 06:25:22PM +0000, Matthew Garrett wrote:
> On Tue, Jan 03, 2012 at 01:02:36PM -0600, Seth Forshee wrote:
> > There are two types of problems that prevent hotkeys from working
> > on many of the machines supported by toshiba_acpi. The first of
> > these is the lack of a functioning SCI for hotkey events. For these
> > machines it is possible to filter the Fn keypresses from the
> > keyboard and generate a notification by executing the ACPI NTFY
> > method.
> > 
> > The second problem is a lack of support for HCI_SYSTEM_EVENT, which
> > is used for reading the hotkey scancodes. On these machines the
> > scancodes can be read by executing the ACPI NTFY method.
> > 
> > This patch fixes both problems by installing an i8042 filter when
> > the NTFY method is present to generate notifications and by
> > detecting which of INFO or HCI_SYSTEM_EVENT is supported for
> > reading scancodes. If neither method of reading scancodes is
> > supported, the hotkey input device is not registered.
> > 
> > Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> 
> It's still an awful way to implement things, but it doesn't seem like 
> there's any alternative, so sure.

I agree. If there's an alternative I couldn't find it, and not for a
lack of trying.

> > +		error = i8042_install_filter(toshiba_acpi_i8042_filter);
> 
> If this is only needed for TOS1900 machines then I think I'd prefer to 
> see it only done on them. Just add a flag to the data field of the IDs 
> and check that.

I checked all the Toshiba DSDTs I have, and every machine with NTFY is a
TOS1900 machine, but only a subset of the TOS1900 machines have NTFY. So
I think we need to still limit it to only machines with NTFY. I can add
an additional check for TOS1900 if that's what you want.

