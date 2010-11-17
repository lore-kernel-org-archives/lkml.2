Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab0KQHwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:52:23 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:37487 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab0KQHwW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Wed, 17 Nov 2010 02:52:22 -0500
Message-Id: <4CE397BF0200007800022AD6@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 17 Nov 2010 07:52:15 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH, v2] x86-64: fix and clean up AMD Fam10 MMCONF
	 enabling
References: <4CE24DF40200007800022737@vpn.id2.novell.com>
 <4CE30524.5080802@kernel.org>
In-Reply-To: <4CE30524.5080802@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.11.10 at 23:26, Yinghai Lu <yinghai@kernel.org> wrote:
> On 11/16/2010 12:25 AM, Jan Beulich wrote:
>> @@ -206,8 +200,10 @@ void __cpuinit fam10h_check_enable_mmcfg
>>  	 * with 256 buses
>>  	 */
>>  	get_fam10h_pci_mmconf_base();
>> -	if (fam10h_pci_mmconf_base_status <= 0)
>> +	if (!fam10h_pci_mmconf_base) {
>> +		pci_probe &= ~PCI_CHECK_ENABLE_AMD_MMCONF;
> 
> case: if no cpu mmconf reg are set by BIOS and later if BSP can not get new 
> base,
> 
> this pci_probe &= line will be called for every AP...

No, because the function itself has

	if (!(pci_probe & PCI_CHECK_ENABLE_AMD_MMCONF))
		return;

at its very beginning.

Jan

