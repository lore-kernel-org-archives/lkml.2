Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2AEUEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:04:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab2AEUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:04:38 -0500
Date: Thu, 5 Jan 2012 14:04:32 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with
 hotkey problems
Message-ID: <20120105200432.GE25386@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-5-git-send-email-seth.forshee@canonical.com>
 <20120105182627.GE24242@srcf.ucam.org>
 <20120105193228.GB25386@ubuntu-macmini>
 <20120105193431.GA26097@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105193431.GA26097@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 07:34:31PM +0000, Matthew Garrett wrote:
> On Thu, Jan 05, 2012 at 01:32:28PM -0600, Seth Forshee wrote:
> 
> > Also a side note of interest: The machines that suffer from this all
> > also have a WMI interface with code to support hotkeys, and that code
> > shouldn't suffer from this problem. Unfortunately these models are the
> > only ones I've seen with this WMI interface, and the code to generate
> > the hotkey events isn't executed if the OS reports itself as Vista or
> > newer.
> 
> In that case, can you check for the presence of the WMI interface and 
> then refuse to bind? That's seem far simpler than adding an unknown 
> number of systems to the blacklist.

Hmm, I suppose I could look for the specific WMI event guid, although
the relationship between the two seems tenuous at best. It would make
sense to me if we were refusing to bind because there was a better
interface available, but Toshiba is obviously treating hotkeys on the
WMI interface as legacy since it's disabled in the BIOS for Vista or
later. INFO seems to be the preferred interface.
