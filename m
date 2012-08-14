Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2HNUUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:20:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45152 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab2HNUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:20:44 -0400
Date: Tue, 14 Aug 2012 13:20:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 5/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120814202040.GB25632@google.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
 <20120811200133.GG2874@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120813073440.GC16654@liondog.tnic>
 <20120813232040.GE25632@google.com>
 <20120814084916.GA16399@liondog.tnic>
 <20120814195247.GA32453@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814195247.GA32453@jshin-Toonie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 02:52:48PM -0500, Jacob Shin wrote:
> > You mean pagetable_reserve() right?
> 
> This is actually needed on every call to init_memory_mapping(),
> 
> My patch 2/5 changes find_early_table_space() to find just enough space
> to map start to end. The pagetable_reserve() will then reserve what we
> actually used. Since init_memory_mapping() is called again and again
> with different start to end ranges, we find space for the page tables
> and reserve them every time.

I thought the function was rebuilding pagetable for the whole memory
area each time.  Maybe I misread.  Does it only build the part which
is newly being mapped?

Thanks.

-- 
tejun
