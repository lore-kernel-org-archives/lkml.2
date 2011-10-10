Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1JJHHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:07:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36783 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1JJHH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:07:29 -0400
Date: Mon, 10 Oct 2011 09:07:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        crash-utility@redhat.com, kexec@lists.infradead.org,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111010070725.GB11577@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"K.Prasad" <prasad@linux.vnet.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
	crash-utility@redhat.com, kexec@lists.infradead.org,
	Andi Kleen <andi@firstfloor.org>,
	"Luck, Tony" <tony.luck@intel.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
	tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
	Valdis.Kletnieks@vt.edu
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com>
 <20111005152537.GB30146@redhat.com>
 <20111007161218.GA2297@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111007161218.GA2297@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 09:42:19PM +0530, K.Prasad wrote:
> The problem, as pointed out by Borislav Petkov in a different mail, is that
> we might end up capturing a vmcore containing corrupted data when the
> same is not required for analysing the cause of the crash.
> 
> Of course, all this is assuming that reading the faulty memory with MCE
> disabled is harmless. However, the effect of a read operation in this
> case is undefined.

Frankly, I don't think that it is undefined - you basically should be
able to read DRAM albeit with the corrupted data in it. However, you
probably best disable the whole DRAM error detection first by clearing
a couple of bits in MC4_CTL_MASK (at least on AMD that should work, I
dunno how Intel does that).

But, regardless, according to Vivek, the "makedumpfile" tool should be
able to jump over poisoned pages and you don't need all the hoopla above
at all, right?

Thanks.

-- 
Regards/Gruss,
    Boris.
