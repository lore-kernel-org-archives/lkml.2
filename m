Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1AMRQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:16:40 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39706 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab1AMRQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:16:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg@redhat.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, horms@verge.net.au,
        nhorman@tuxdriver.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, vgoyal@redhat.com
References: <F7CB3D97D99F33indou.takao@jp.fujitsu.com>
	<4D06E7FE.5000600@jp.fujitsu.com>
	<9CB9BB8ED64BAindou.takao@jp.fujitsu.com>
	<20110113163838.GA21289@srcf.ucam.org>
Date: Thu, 13 Jan 2011 09:16:26 -0800
In-Reply-To: <20110113163838.GA21289@srcf.ucam.org> (Matthew Garrett's message
	of "Thu, 13 Jan 2011 16:38:38 +0000")
Message-ID: <m1bp3kbu6t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/qTvT1g+IoRR5/RJwzL3PzmfFl1rXwCPI=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2][EFI] Run EFI in physical mode
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> writes:

> We're seeing issues with some Dell hardware when EFI is run in physical 
> mode - it seems that Windows uses virtual mode, so the physical path is 
> never exercised. I'm not sure that changing the default to physical is 
> going to be possible without compatibility issues.

The bootloaders use physical mode, and there shouldn't be a separate
physical vs virtual mode.  It should be the same code with or without
relocations applied.  At worst we can set virtual address to the
physical address, on buggy boards.

Honestly if the problem is the EFI code is so buggy we can't use it
in physical mode the answer is almost certainly not to use the
buggy EFI code.

The only bits that I don't think have an alternative are the firmware
variable accesses.   Which are a nice to have, but not a show stopper
anywhere.

Eric
