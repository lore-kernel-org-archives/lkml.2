Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830Ab0KQQD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:03:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18514 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab0KQQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:03:27 -0500
Message-ID: <4CE3FCB5.6030909@oracle.com>
Date: Wed, 17 Nov 2010 08:03:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 tree related)
References: <20101117134820.bca8d764.sfr@canb.auug.org.au>
In-Reply-To: <20101117134820.bca8d764.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/10 18:48, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
> 
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `iwl_legacy_mac_reset_tsf':
> (.opd+0xf00): multiple definition of `iwl_legacy_mac_reset_tsf'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.opd+0x90): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `.iwl_legacy_mac_config':
> (.text+0x50ae4): multiple definition of `.iwl_legacy_mac_config'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.text+0x2b34): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `.iwl_legacy_mac_bss_info_changed':
> (.text+0x4f778): multiple definition of `.iwl_legacy_mac_bss_info_changed'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.text+0x17c8): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `.iwl_legacy_tx_cmd_protection':
> (.text+0x4dfb0): multiple definition of `.iwl_legacy_tx_cmd_protection'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.text+0x0): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `iwl_legacy_mac_bss_info_changed':
> (.opd+0xee8): multiple definition of `iwl_legacy_mac_bss_info_changed'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.opd+0x78): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `iwl_legacy_tx_cmd_protection':
> (.opd+0xe70): multiple definition of `iwl_legacy_tx_cmd_protection'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.opd+0x0): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `.iwl_isr_legacy':
> (.text+0x4e0e0): multiple definition of `.iwl_isr_legacy'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.text+0x130): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `.iwl_legacy_mac_reset_tsf':
> (.text+0x50620): multiple definition of `.iwl_legacy_mac_reset_tsf'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.text+0x2670): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `iwl_isr_legacy':
> (.opd+0xe88): multiple definition of `iwl_isr_legacy'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.opd+0x18): first defined here
> drivers/net/wireless/iwlwifi/iwl3945.o: In function `iwl_legacy_mac_config':
> (.opd+0xf18): multiple definition of `iwl_legacy_mac_config'
> drivers/net/wireless/iwlwifi/iwlagn.o:(.opd+0xa8): first defined here
> 
> I should have known when I reported the warning ...
> 
> Caused by commit dd0dd411f7178a20ea93a3cfa39123f078a07e25 ("iwlwifi: fix
> modular legacy build errors").
> 
> I have reverted that commit for today.

Ack.  John, please drop/revert that patch.

Sorry about the problem.
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
