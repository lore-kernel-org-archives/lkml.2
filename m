Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2HNItY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:49:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41167 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab2HNItV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:49:21 -0400
Date: Tue, 14 Aug 2012 10:49:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 5/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120814084916.GA16399@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Jacob Shin <jacob.shin@amd.com>, X86-ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
 <20120811200133.GG2874@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120813073440.GC16654@liondog.tnic>
 <20120813232040.GE25632@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120813232040.GE25632@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 04:20:40PM -0700, Tejun Heo wrote:
> I meant the patch should come before the patch making multiple calls
> to init_memory_mapping().

Ah, this makes sense.

> > > Also, there seem to be other stuff which need to be moved out.
> > 
> > Which are those pls?
> 
> Rebuilding pgtable on each invocation?

You mean pagetable_reserve() right?

Yes, Jacob, you basically might want to carve out all functionality
from init_memory_mapping() which is independent from its start and end
args and do the carving in a pre-patch or two to 1/5.

Thanks.

-- 
Regards/Gruss,
    Boris.
