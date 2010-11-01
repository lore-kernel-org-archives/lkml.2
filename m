Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0KADLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 23:11:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19519 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab0KADLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 23:11:45 -0400
Message-ID: <4CCE2F62.7050202@oracle.com>
Date: Sun, 31 Oct 2010 20:09:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Lee@kernel.org, Chun-Yi <joeyli.kernel@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: Tree for October 28 (acpi_video)
References: <20101028142031.5a4d6612.sfr@canb.auug.org.au> <20101029090131.68709a71.randy.dunlap@oracle.com> <alpine.LFD.2.00.1010291406560.3423@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1010291406560.3423@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/10 11:18, Len Brown wrote:
>> drivers/built-in.o: In function `acpi_video_bus_put_one_device':
>> video.c:(.text+0x9d794): undefined reference to `backlight_device_unregister'
> 
> Invalid .config, as ACPI_VIDEO depends on BACKLIGHT_CLASS_DEVICE, which is not set.
> 
> This breakage is the infamous "select in Kconfig doesn't" bug,
> which has apparently claimed a new victim, STUB_POULSBO:
> 
> (STUB_POULSBO && HAS_IOMEM && PCI && ACPI || DRM_I915 && <choice> && 
> AGP_INTEL && ACPI || DRM_NOUVEAU && STAGING && !STAGING_EXCLUDE_BUILD && 
> DRM && PCI && ACPI) selects ACPI_VIDEO which has unmet direct dependencies 
> (ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT)
> 
> commit e26fd1199ebab0d469fc3e037da5932d382f0669
> Author: Lee, Chun-Yi <joeyli.kernel@gmail.com>
> Date:   Wed Oct 20 13:51:19 2010 +0800
> 
>     gpu: Add Intel GMA500(Poulsbo) Stub Driver
>     
>     Currently, there have no GMA500(Poulsbo) native video driver to 
> support
>     intel opregion. So, use this stub driver to enable the acpi backlight
>     control sysfs entry files by requrest acpi_video_register.
>     
>     [airlied: fix warnings]
>     
>     Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 

I think that it needs this patch (from 2010-OCT-13):
  http://lkml.org/lkml/2010/10/13/270

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
