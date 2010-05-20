Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0ETTKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:10:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39918 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0ETTKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:10:13 -0400
Date: Thu, 20 May 2010 12:09:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, David Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for May 20 (radeon_pm build problem)
Message-Id: <20100520120929.364e1f87.randy.dunlap@oracle.com>
In-Reply-To: <20100520163042.9486e077.sfr@canb.auug.org.au>
References: <20100520163042.9486e077.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BF58904.0068:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 16:30:42 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> We are in the merge window again.  I remind you all not to add stuff for
> 2.6.36 to your linux-next trees until after 2.6.35-rc1.
> 
> Changes since 20100519:


CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
CONFIG_POWER_SUPPLY=m

causes

radeon_pm.c:(.text+0x13d58f): undefined reference to `power_supply_is_system_supplied'
radeon_pm.c:(.text+0x13e72e): undefined reference to `power_supply_is_system_supplied'


The Kconfig for DRM_RADEON_KMS says:

config DRM_RADEON_KMS
	bool "Enable modesetting on radeon by default - NEW DRIVER"
	depends on DRM_RADEON
	depends on POWER_SUPPLY

Aha.  DRM_RADEON_KMS is a bool, so
	depends on DRM_RADEON && POWER_SUPPLY
evaluates to y.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
