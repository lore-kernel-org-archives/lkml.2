Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1CKWP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:15:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43949 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1CKWPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:15:25 -0500
Date: Fri, 11 Mar 2011 22:15:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] X86: Revamp reboot behaviour to match Windows more
	closely
Message-ID: <20110311221517.GA24173@srcf.ucam.org>
References: <1299877940-6870-1-git-send-email-mjg@redhat.com> <201103112308.18221.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103112308.18221.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:08:18PM +0100, Rafael J. Wysocki wrote:
> On Friday, March 11, 2011, Matthew Garrett wrote:
> > Windows reboots by hitting the ACPI reboot vector (if available), trying
> > the keyboard controller, hitting the ACPI reboot vector again and then
> > giving the keyboard controller one last go. Rework our reboot process a
> > little to default to matching this behaviour, although we'll fall through
> > to attempting a triple fault if nothing else works.
> 
> Does this fix a particular problem observed in practice?

Yup. We're seeing an increasing number of machines that don't implement 
the legacy keyboard controller at all and fail to reboot if you poke it. 
The expectation appears to be that you use the ACPI reboot vector on 
these machines.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
