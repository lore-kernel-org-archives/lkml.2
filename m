Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab1GKRZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:25:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24445 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab1GKRZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:25:16 -0400
Date: Mon, 11 Jul 2011 13:23:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, amwang@redhat.com, ebiederm@xmission.com,
        vgoyal@redhat.com, rdunlap@xenotime.net, lenb@kernel.org,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH v2] acpi: introduce "acpi_rsdp=" parameter for kdump
Message-ID: <20110711172318.GA18279@dumpdata.com>
References: <E8CC3FDD41FF9Findou.takao@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E8CC3FDD41FF9Findou.takao@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E1B3191.0100:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:14:41AM -0400, Takao Indoh wrote:
> Revised version of the patch which was posted by Cong WANG
> 
> v1:
> https://lkml.org/lkml/2011/3/10/206
> 
> There is a problem with putting the first kernel in EFI virtual mode,
> it is that when the second kernel comes up it tries to initialize the
> EFI again and once we have put EFI in virtual mode we can not really
> do that.
> 
> Actually, EFI is not necessary for kdump, we can boot the second kernel
> with "noefi" parameter, but the boot will mostly fail because 2nd kernel
> cannot find RSDP.
> 
> In this situation, we introduced "acpi_rsdp=" kernel parameter, so that
> kexec-tools can pass the "noefi acpi_rsdp=X" to the second kernel to make
> kdump works.
> 
> Changes in v2:
> * Change parameter name from "acpi_addr" to "acpi_rsdp"
> * Add CONFIG_KEXEC

How will the tools get the physical address of the RSDP?
