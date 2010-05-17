Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0EQPPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:15:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab0EQPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:15:39 -0400
Date: Mon, 17 May 2010 08:12:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       markh@compro.net, dmarkh@cfl.rr.com, andi@firstfloor.org,
       alain@knaff.lu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
In-Reply-To: <20100517145943.GV5888@alberich.amd.com>
Message-ID: <alpine.LFD.2.00.1005170811400.4195@i5.linux-foundation.org>
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <20100121190952.GA32523@linux-os.sc.intel.com>
 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl> <20100125171059.GB5041@alberich.amd.com> <20100517145943.GV5888@alberich.amd.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Andreas Herrmann wrote:
> 
> FYI. I've tried to trigger the publication of errata information for that
> chipset. Finally this has happened.
> 
> The discussed problem is indeed due to an erratum. See erratum #27 in
> http://support.amd.com/us/Embedded_TechDocs/46837.pdf
> 
> The suggested workaround for this is to disable HPET MSI if LPC
> devices are used. I doubt that there is a convenient way for Linux to
> find out whether LPC devices are used. Thus I think the only solution
> to safely avoid the problem is the currently implemented quirk to
> disable HPET MSI on this chipset.

Goodie. It would be good to point this out in the source too. Would you be 
willing to send in a patch that documents this quirk as a result of that 
erratum #27, so that we don't lose sight of why we're doing that odd MSI 
disable?

		Linus
