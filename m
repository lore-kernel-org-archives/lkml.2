Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1JLAUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:20:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49768 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1JLAUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:20:38 -0400
Date: Wed, 12 Oct 2011 02:20:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type NT_NOCOREDUMP to capture slimdump
Message-ID: <20111012002032.GF14482@one.firstfloor.org>
References: <20111003070735.GJ2223@in.ibm.com> <20111003073203.GA22694@in.ibm.com> <20111004140437.GA28306@redhat.com> <20111005071844.GB2235@in.ibm.com> <20111005152537.GB30146@redhat.com> <20111007161218.GA2297@in.ibm.com> <20111010070725.GB11577@liondog.tnic> <20111011184434.GB32316@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011184434.GB32316@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, in any case we may not be able to disable machine-check exceptions
> (MCEs) only within the context of kexec'ed kernel. Let me know if I've
> missed something here.

You can disable signalling in the main machine check register,
then you won't get any machine check interrupts. No need to mess
with any CPU specific banks.

See the old mce tree that kernel.org ate for a patch that just did that
during the kcore copy.

-Andi
