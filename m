Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab0FHWQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:16:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43952 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab0FHWQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:16:32 -0400
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: <alan@linux.intel.com>, <jacob.jun.pan@linux.intel.com>,
       <arjan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>, <mingo@elte.hu>, <feng.tang@intel.com>,
       <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org>
	<20100608201258.6c813085@linux.intel.com>
	<SNT125-W593A227B1D8643303EE24DC3D60@phx.gbl>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Jun 2010 15:16:27 -0700
In-Reply-To: <SNT125-W593A227B1D8643303EE24DC3D60@phx.gbl> (Yuhong Bao's message of "Tue\, 8 Jun 2010 13\:56\:46 -0700")
Message-ID: <m18w6p5fwk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: yuhongbao_386@hotmail.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com, jacob.jun.pan@linux.intel.com, alan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yuhong Bao <yuhongbao_386@hotmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuhong Bao <yuhongbao_386@hotmail.com> writes:

>> IRQ 14/15 is wrong for ATA today as its AHCI based on modern boxes
> Not to mention even before that there was native mode IDE!In fact, XP SP1 and later support switching to native mode IDE on BIOSes supporting it as described in this document:http://www.microsoft.com/whdc/device/storage/Native-modeATA.mspx

One of these days we may even get a system where the designers really
care for being simple and easy to use by software.  Where all devices
will be discoverable pci devices, and all irqs will be msi or msi-x.  No
ioapics, no irq routing tables, just nice simple standards conformant
hardware that we already support.

Until then I guess we get things like Moorestown which are effectively
a reinvention of ISA based systems, with different firmware, and
different non-standard ISA devices.  It isn't particularly fun to
smash yet another incompatible idea into the existing infrastructure.
The cleanups that introduce modularity, flexibility, and
maintainability for irq handling are barely keeping ahead of new
poorly integrated features that make the code brittle again.

Eric
