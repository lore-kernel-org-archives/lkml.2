Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1GXXWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:22:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58846 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1GXXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:22:13 -0400
MIME-Version: 1.0
Date: Sun, 24 Jul 2011 17:22:12 -0600
Message-ID: <CAC-0EqgJtddENZO_=kmjSy8-bocLf+ansDbpGwbkb+a3YLakLQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] firmware: Add DMI entry types to the headers
From: David Hubbard <david.c.hubbard@gmail.com>
To: Mike Waychison <mikew@google.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> In preparation for the upcoming commits, introduce the DMI entry types to
> the headers.  These type names are based on those specified in the DMTF
> SMBIOS specification version 2.7.1.
>
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  include/linux/dmi.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 47 insertions(+), 0 deletions(-)

I noticed a missing entry w.r.t. dmi_smbios_structure_type() in dmidecode.c:

--- include/linux/dmi.h	2011-07-24 17:14:34.000000000 -0600
+++ include/linux/dmi.h	2011-07-24 17:14:49.000000000 -0600
@@ -57,6 +57,7 @@
 	DMI_ENTRY_OOB_REMOTE_ACCESS,
 	DMI_ENTRY_BIS_ENTRY,
 	DMI_ENTRY_SYSTEM_BOOT,
+	DMI_ENTRY_64_MEM_ERROR,
 	DMI_ENTRY_MGMT_DEV,
 	DMI_ENTRY_MGMT_DEV_COMPONENT,
 	DMI_ENTRY_MGMT_DEV_THRES,

I got a hint something was up when I saw that dmi_decode() in
drivers/firmware/dmi_scan.c says:

case 38: /* IPMI Device Information */

But DMI_ENTRY_IPMI_DEV == 37, so this should resolve the discrepancy.

I'm using 2.6.39, so I apologize if this information is out of date.
I'm not subscribed to the lkml; please CC me.

Cheers,
David
