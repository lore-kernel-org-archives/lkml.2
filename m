Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0KXGJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:09:31 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57964 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0KXGJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:09:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=bac3oVLSsTVkMgM7iH1yH7UeAFOAiv+7l/aEV3aXH5v6rTu3eX0Rke9ZKrRrpVEbJZ
         35kSI2YhV2EupkzvxlJoPpmFiH+p6yzDKTaeR4uMd8gQqSsmvd0dcNsC8QBWzcc52DFy
         sEeMye8blGWx7WQzfHEIecVgkDLik5rV3HUJk=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 24 Nov 2010 07:09:28 +0100
Message-ID: <AANLkTinVUkgZKbAkQ3_27Jw3cXJ7qySxm1UMFSReujfp@mail.gmail.com>
Subject: Re: linux-next: Tree for November 24 (iwlwifi-fix)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Cc: sfr@canb.auug.org.au, Randy Dunlap <randy.dunlap@oracle.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch from Randy from [1] still applies, but my build-log from
yesterday's linux-next shows:

$ grep ^WARNING build_linux-next_next20101123.dileks.1.log | grep iwl
WARNING: drivers/net/wireless/iwlwifi/iwlagn:
'iwl_legacy_tx_cmd_protection' exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_isr_legacy'
exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn:
'iwl_legacy_mac_bss_info_changed' exported twice. Previous export was
in drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn:
'iwl_legacy_mac_reset_tsf' exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_config'
exported twice. Previous export was in
drivers/net/wireless/iwlwifi/iwl3945.ko

The fix is doing:

[ drivers/net/wireless/iwlwifi/Makefile ]
...
-iwlcore-$(CONFIG_IWL3945) += iwl-legacy.o
-iwlcore-$(CONFIG_IWL4965) += iwl-legacy.o
...
-iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
+iwlagn-$(CONFIG_IWL4965) += iwl-4965.o iwl-legacy.o
...
-iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
+iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
iwl-3945-led.o iwl-legacy.o

So why do I see warnings in iwl3945.ko but not in iwl-4965.ko?

Is that fix still required? Fixed in wireless-next-2.6?

Regards,
- Sedat -

[1] https://patchwork.kernel.org/patch/322492/
