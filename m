Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1E0SOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:14:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53828 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1E0SOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:14:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck\, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
References: <20110526170722.GB23266@in.ibm.com>
	<20110526172305.GA18295@in.ibm.com>
Date: Fri, 27 May 2011 11:14:00 -0700
In-Reply-To: <20110526172305.GA18295@in.ibm.com> (K. Prasad's message of "Thu,
	26 May 2011 22:53:05 +0530")
Message-ID: <m1fwo08107.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18E/krcJc5TJLS1VoopcAxIQaogejsATU8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.0 XMSlimDrugH Weight loss drug headers
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;prasad@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE generated crashes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> slimdump: Capture slimdump for fatal MCE generated crashes
>
> System crashes resulting from fatal hardware errors (such as MCE) don't need
> all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> retains only essential information while discarding the old memory.

Ugh.  You are changing the kernel to change userspace policy?

And because of how you have previous populated this we won't get the
notes to let us extract dmesg easily.

No thanks.  Let's change this in userspace instead.

You are going to an awful lot of work to avoid a problem that doesn't
happen to in practice.

Patching makedumpfile to key in on an mce note would be more appropriate.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
