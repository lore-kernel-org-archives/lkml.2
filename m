Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0FVSbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:31:04 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:56050 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752002Ab0FVSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:31:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MRa4iXZtGRjMHIC66M4igyfgo8UXARNkBDNp9/UHYLTo865dNna/OyCR+ux8OeBpLs9UqMn6W5NGiyB92+/7jjges7skZ+ZUKu2rFpHQSQ98KMP8rQ7t3u7QLezzfTS/;
Date: Tue, 22 Jun 2010 11:29:08 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Disable ASPM if the platform won't provide _OSC
 control for PCIe
Message-ID: <20100622112908.4122ceb2@virtuousgeek.org>
In-Reply-To: <201006222017.30023.rjw@sisk.pl>
References: <1277220343-25168-1-git-send-email-mjg@redhat.com>
	<201006222017.30023.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 20:17:29 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, June 22, 2010, Matthew Garrett wrote:
> > The PCI SIG documentation for the _OSC OS/firmware handshaking interface
> > states:
> > 
> > "If the _OSC control method is absent from the scope of a host bridge
> > device, then the operating system must not enable or attempt to use any
> > features defined in this section for the hierarchy originated by the host
> > bridge."
> > 
> > The obvious interpretation of this is that the OS should not attempt to use
> > PCIe hotplug, PME or AER - however, the specification also notes that an
> > _OSC method is *required* for PCIe hierarchies, and experimental validation
> > with An Alternative OS indicates that it doesn't use any PCIe functionality
> > if the _OSC method is missing. That arguably means we shouldn't be using
> > MSI or extended config space, but right now our problems seem to be limited
> > to vendors being surprised when ASPM gets enabled on machines when other
> > OSs refuse to do so. So, for now, let's just disable ASPM if the _OSC
> > method doesn't exist or refuses to hand over PCIe capability control.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
