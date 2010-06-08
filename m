Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0FHVoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:44:55 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:53154 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754847Ab0FHVox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:44:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZIuCx2hcpyudavg7fTjMjA1GcIsrs4D72QcFkWZDGTD61m3W5ebFqW2OSopvOdzPDl2Uqw+s6uMvpf8vnOilmDUrWKfJZiglcF6YLlofOBP0lLqTuK6N5z1lHJFRnpN3;
Date: Tue, 8 Jun 2010 14:43:50 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad
 one
Message-ID: <20100608144350.366071fd@virtuousgeek.org>
In-Reply-To: <4C0813D7.7080900@oracle.com>
References: <bug-16009-13546@https.bugzilla.kernel.org/>
	<201005191637.13177.bjorn.helgaas@hp.com>
	<201005202236.20444.bjorn.helgaas@hp.com>
	<201006021536.43333.bjorn.helgaas@hp.com>
	<4C070ECA.2020309@oracle.com>
	<4C0813D7.7080900@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010 13:43:03 -0700
Yinghai Lu <yinghai.lu@oracle.com> wrote:

> 
> Make sure We can reject wrong size from BIOS.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16009
> Yannick found that video does not work with 2.6.34
> 
> the root cause:
> BIOS assigned wrong range to pci bridge.  and before 2.6.34 kernel will
> just get range that is needed.
> for 2.6.34.
> |	d65245c PCI: don't shrink bridge resources
> will try to range size is bigger than old one.
> (used by boot stage multi-try to get big BAR size for pci bridge,
>  and pcie hotplug to get big range)
> 
> So try to 0 for old size for pci bridge in this boot stage case.
> 
> Reported-by: Yannick <yannick.roehlly@free.fr>
> Analyzed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

Bjorn, are you ok with this version?  It would probably help to have
some comments here too (I can add them), indicating that we'll try to
reassign the resource later, rather than just ignoring it as the
existing comment implies.

-- 
Jesse Barnes, Intel Open Source Technology Center
