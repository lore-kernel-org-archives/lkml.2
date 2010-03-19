Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0CSUiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:38:50 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:33544 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751315Ab0CSUir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:38:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=twiYlJkkLHj9bD2qk44v7S7zy8OrLkxYMOz9GYMeZe4AnKoKRYhs9x+0PMEAbdlEZNgnct4ox4pxbHL2pCM3MSfxhKBXvXEPdf+Sr71hngcA9hL+hC6fzWxyfWMUge0j;
Date: Fri, 19 Mar 2010 13:38:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Pete Zaitcev <zaitcev@redhat.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: ignore Consumer/Producer bit and parse
 additional _CRS resources
Message-ID: <20100319133848.35465d9a@jbarnes-piketon>
In-Reply-To: <20100316201134.24527.87006.stgit@bob.kio>
References: <20100316201046.24527.79634.stgit@bob.kio>
	<20100316201134.24527.87006.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 14:11:34 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> We previously used only resources marked "Producer," i.e., those the bridge
> forwards downstream.  But BIOSes haven't used that bit consistently, so it's
> useless.  For bridge devices, we have to assume *all* ACPI resources are
> forwarded downstream.  Non-Producer bridge resources typically appear in
> PCI config space and are not described in ACPI.
> 
> In addition to ACPI_RESOURCE_TYPE_ADDRESS{16,32,64}, parse these types:
> 
>     ACPI_RESOURCE_TYPE_IO
>     ACPI_RESOURCE_TYPE_FIXED_IO
>     ACPI_RESOURCE_TYPE_MEMORY24
>     ACPI_RESOURCE_TYPE_MEMORY32
>     ACPI_RESOURCE_TYPE_FIXED_MEMORY32
>     ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64
> 
> This basically reimplements what drivers/pnp/pnpacpi/rsparser.c already
> does, and I plan to take advantage of that, but we're not quite ready to
> do it yet because it will require converting pci_root.c from an ACPI
> driver to a PNP driver.
> 
> This is a possible fix for http://bugzilla.kernel.org/show_bug.cgi?id=15533
> reported by Pete Zaitcev <zaitcev@redhat.com>.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
> 

Applied to my for-linus tree, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
