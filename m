Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0JLHp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:45:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46368 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab0JLHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:45:27 -0400
Date: Tue, 12 Oct 2010 09:45:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Subject: Re: [PATCH 14(16] pramfs: memory protection
Message-ID: <20101012074522.GA20436@basil.fritz.box>
References: <4CB1EBA2.8090409@gmail.com>
 <87aamm3si1.fsf@basil.nowhere.org>
 <4CB34A1A.3030003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB34A1A.3030003@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 07:32:10PM +0200, Marco Stornelli wrote:
> Il 10/10/2010 18:46, Andi Kleen ha scritto:
> > This won't work at all on x86 because you don't handle large 
> > pages.
> > 
> > And it doesn't work on x86-64 because the first 2GB are double
> > mapped (direct and kernel text mapping)
> > 
> > Thirdly I expect it won't either on architectures that map
> > the direct mapping with special registers (like IA64 or MIPS)
> 
> Andi, what do you think to use the already implemented follow_pte
> instead? 

Has all the same problems. Really you need an per architecture
function. Perhaps some architectures could use a common helper,
but certainly not all.

x86 already has some infrastructure for this, but it currently
has serious problems too (like not merging mappings on unmap) 
and is generally overdesigned ugly code.

-Andi
