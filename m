Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214Ab0HLOlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:41:45 -0400
Received: from 8bytes.org ([88.198.83.132]:45210 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab0HLOlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:41:44 -0400
Date: Thu, 12 Aug 2010 16:41:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Borislav Petkov <bp@amd64.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD
	machines
Message-ID: <20100812144142.GY23755@8bytes.org>
References: <1280940316-7966-1-git-send-email-bp@amd64.org> <1280940316-7966-2-git-send-email-bp@amd64.org> <4C59F24B.1010702@zytor.com> <20100805074503.GI18307@amd.com> <4C5AC736.20903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5AC736.20903@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:14:14AM -0700, H. Peter Anvin wrote:
> On 08/05/2010 12:45 AM, Roedel, Joerg wrote:
> Correct, again.  It's unclear to me if we can get away with the very
> simple 64-bit approach -- in particular, not including all the 1:1
> mappings in the kernel -- for all future users, though.

Yeah, We could probably use the same symbol names for the trampoline and
the swapper page-table on 32 and 64 bit and merge the code that handles
it between the architectures. Shouldn't be too difficult. We cook
something up :-)
But do you mind to take this patch first? It fixes the occurence of an
erratum on AMD hardware, it is a quite simple fix compared to the rework
suggested. In fact, I would like to have a simple patch to fix the
problem first (and backport it as necessary) and then go the way to
rework the current code differences between 32 and 64 bit.

	Joerg

