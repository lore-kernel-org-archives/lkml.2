Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0FLXBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 19:01:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0FLXBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 19:01:46 -0400
Message-ID: <4C1411BD.5070308@zytor.com>
Date: Sat, 12 Jun 2010 16:01:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
References: <20100612060322.29053.94187.reportbug@feather> <1276351120.14011.194.camel@localhost> <4C13D1E7.7060604@zytor.com> <20100612185538.GA4511@feather> <4C13F102.7000509@zytor.com> <20100612222634.GA1785@feather>
In-Reply-To: <20100612222634.GA1785@feather>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2010 03:26 PM, Josh Triplett wrote:
> 
> Done.  I've attached the output of meminfo with the e820 hook as
> meminfo-grub-hooked.jpg, and without the e820 hook as
> meminfo-unhooked.jpg.
> 
> Everything looks identical except for the region GRUB hooked right below
> the first reserved region; the unhooked version has available memory
> from 0-0x9cbf0, and the hooked version has available memory from
> 0-0x9cba0, then reserved from 0x9cba0-0x9cbec, then 4 bytes of available
> memory, and then the same reserved region as before.
> 

The new reserved area that Grub hooks is located inside a FBM ("DOS
RAM") reserved area, so Grub is somehow using memory that someone else
has already reserved!  The normal thing is to reserve something in FBM
and not in INT 15h if it is to be reserved only until the protected-mode
operating system starts, but in this case Grub puts something in there
which is a real-mode hook.  It *will* have overwritten something at this
point, the question is just what (and I have no idea how to find that out.)

Note that the unmodified entry conditions (unhooked) has FBM quite a bit
lower than the reserved area.  Something else that really confuses me is
that although the memory map has changed, the INT 15h vector itself is
still the same, so I'm really confused about how the actual hooking
happens in the first place...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

