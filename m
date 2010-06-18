Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295Ab0FRQim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:38:42 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:47458 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757348Ab0FRQik convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:38:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YYF95cujtJ4CjcCAJ/vZqjqPtd+Fj0KC8SCiqjVlbl6IX0aAdH5SUpcNykM6KzwiePKGJsSDTgage9Mxudr78rp5e2m6KECpDd40St3rR2iP+0ciKZopEGUrxsVebUsh;
Date: Fri, 18 Jun 2010 09:37:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI / PM: Do not use native PCIe PME by default
Message-ID: <20100618093701.681dc238@virtuousgeek.org>
In-Reply-To: <201006181704.22550.rjw@sisk.pl>
References: <201006181704.22550.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 17:04:22 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Commit c7f486567c1d0acd2e4166c47069835b9f75e77b
> (PCI PM: PCIe PME root port service driver) causes the native PCIe
> PME signaling to be used by default, if the BIOS allows the kernel to
> control the standard configuration registers of PCIe root ports.
> However, the native PCIe PME is coupled to the native PCIe hotplug
> and calling pcie_pme_acpi_setup() makes some BIOSes expect that
> the native PCIe hotplug will be used as well.  That, in turn, causes
> problems to appear on systems where the PCIe hotplug driver is not
> loaded.  The usual symptom, as reported by Jaroslav Kameník and
> others, is that the ACPI GPE associated with PCIe hotplug keeps
> firing continuously causing kacpid to take substantial percentage
> of CPU time.
> 
> To work around this issue, change the default so that the native
> PCIe PME signaling is only used if directly requested with the help
> of the pcie_pme= command line switch.
> 
> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=15924 , which is
> a listed regression from 2.6.33.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Jaroslav Kameník <jaroslav@kamenik.cz>
> Tested-by: Antoni Grzymala <antekgrzymala@gmail.com> 
> ---

Applied to my for-linus tree, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
