Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0JEXik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:38:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48419 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab0JEXij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:38:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 3/5] ACPI: Bind implicit GPE dependencies to PCI devices
Date: Wed, 6 Oct 2010 01:37:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <1286216549-5438-1-git-send-email-mjg@redhat.com> <1286216549-5438-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1286216549-5438-4-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010060137.29369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 04, 2010, Matthew Garrett wrote:
> Several platforms provide GPE information about devices in ACPI, but provide
> no ACPI methods to handle these at runtime. Provide a default handler for
> this case and bind it to PCI devices as they're discovered in ACPI space.
> Keep the methods associated in case they have side effects.

I think I'd prefer it if ACPICA maintained a list of devices to Notify() if
the given GPE triggers.  That would require us to redefine
acpi_gpe_can_wake() a bit, but that should be generally more
efficient.

Thanks,
Rafael
