Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab0EUPN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:13:59 -0400
Received: from king.tilera.com ([72.1.168.226]:26941 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512Ab0EUPN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:13:58 -0400
Message-ID: <4BF6A325.6010001@tilera.com>
Date: Fri, 21 May 2010 08:13:41 -0700
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> 	<AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com> 	<4BF5892E.5080302@tilera.com> <AANLkTikN6S2nMLAw0uQ9_BosJ0i3_vdpajVrVq0Kllp7@mail.gmail.com>
In-Reply-To: <AANLkTikN6S2nMLAw0uQ9_BosJ0i3_vdpajVrVq0Kllp7@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2010 15:13:56.0550 (UTC) FILETIME=[3B647E60:01CAF8F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2010 9:52 PM, Barry Song wrote:
> On 5/20/2010 1:04 AM, Barry Song wrote:
>>> Your patch is not compilable, and the subject doesn't match well with
>>> the content. I think you need re-organize patches.
>>>       
> Where does the blade_pci symbol come from? "No matches found" by a
> grep. Is it exported in your local codes?
> Why not just use #if CONFIG_TILE to cover your quirk_tile_blade. And
> where is CONFIG_TILE?
>   

Oh, I see; I thought you were referring to the other bit of quoted
patch.  Yes, this should be guarded by #ifdef TILE_CONFIG - thanks!

> I guess all will be explained by your arch codes, but this patch
> depends on your arch codes, so it shouldn't be here by itself.
>   

The arch code is all at

http://www.tilera.com/scm/linux-2.6.34-arch-tile.tar.bz2

I have been reluctant to send it to LKML as an email patch, since it's
270 files, 87 KLoC, about 2.5 MB.  I could break it down into multiple
patches (arch/tile/kernel/, arch/tile/mm, arch/tile/lib, etc.).

I solicit opinions from the community as to what is the best approach :-)

Meanwhile I'll resend the original platform-independent changes (the
MAINTAINER stanza, one line in the PIC Makefile, and the quirk change)
as updated git-am patches.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


