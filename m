Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab0J1ODK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:03:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49079 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab0J1ODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:03:06 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=Ot7i4hbfXkcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7UMGYAjCss70YIensz4A:9 a=lBh8Z4tLoFeElr6dRx2sYmw49_sA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: bug in streamline_config.pl
From: Steven Rostedt <rostedt@goodmis.org>
To: member graysky <graysky@archlinux.us>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTik5RRYFgBC2oY-9EYWRh7Q72SqhRB4m_2w5Oia4@mail.gmail.com>
References: <AANLkTikHTu=MsoYu=PPxAh7t6oGPKnp=FybNMPXkMSx3@mail.gmail.com>
	 <1288013006.18238.0.camel@gandalf.stny.rr.com>
	 <AANLkTikdVu4k21K0G9C8vZ54=yGiBFKpGxdPaZM9cEPv@mail.gmail.com>
	 <1288041261.18238.7.camel@gandalf.stny.rr.com>
	 <AANLkTimgsbFWz34m52+=bgYiccCMc3acSE40qDhCM2tx@mail.gmail.com>
	 <1288064854.18238.66.camel@gandalf.stny.rr.com>
	 <AANLkTik5RRYFgBC2oY-9EYWRh7Q72SqhRB4m_2w5Oia4@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 10:03:05 -0400
Message-ID: <1288274585.18238.241.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, you just found a bug ;-)

You complained about CONFIG_DRM_RADEON being selected (that's ATI
Radean). Here's why:

CONFIG_DRM_RADEON select by dependency on HWMON
CONFIG_HWMON_VID selected by direct module hwmon_vid

You had hwmon_vid enabled. This module gets selected by other modules,
one being DRM_RADEON.

If a module is selected by other modules and does not have a prompt to
select itself, then I have to select the other modules because I don't
know what module is needed to make sure this module is selected (again,
I can add logic to see if the select is satisfied by the direct
selections).

But, (here's the bug) HWMON has a prompt!  But it's a different kind of
prompt. It's a menuconfig option and not a config option. By making this
one-liner fix, I just removed the following options from your config:

 CONFIG_HOTPLUG_PCI=m
 CONFIG_RFKILL=m
 CONFIG_SFC=m
 CONFIG_DRM=m
 CONFIG_DRM_KMS_HELPER=m
 CONFIG_DRM_RADEON=m
 CONFIG_DRM_I915=m
 CONFIG_FB_DDC=m
 CONFIG_FB_NVIDIA=m
 CONFIG_FB_RIVA=m
 CONFIG_FB_RADEON=m
 CONFIG_FB_SAVAGE=m
 CONFIG_FB_3DFX=m
 CONFIG_DRM_NOUVEAU=m
 CONFIG_THINKPAD_ACPI=m
 CONFIG_EEEPC_LAPTOP=m

I'll go ahead and make sure that this fix makes it into 2.6.37

-- Steve



