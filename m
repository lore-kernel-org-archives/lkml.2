Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0EXKvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab0EXKvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:51:52 -0400
Message-ID: <4BFA5A3F.4040005@redhat.com>
Date: Mon, 24 May 2010 13:51:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Cesar Eduardo Barros <cesarb@cesarb.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: Swap checksum
References: <4BF81D87.6010506@cesarb.net> <1274551731-4534-3-git-send-email-cesarb@cesarb.net> <4BF94792.5030405@redhat.com> <4BF97AC2.1040505@cesarb.net> <4BFA1F92.2080802@redhat.com> <20100524073259.GW2516@laptop>
In-Reply-To: <20100524073259.GW2516@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 10:32 AM, Nick Piggin wrote:
>
> I wonder, though. If we no longer trust block devices to give the
> correct data back, should we provide a meta block device to do error
> detection?

Some block devices do provide space for end-to-end checksums.  For the 
ones that don't, I see no efficient way of adding it (either we turn one 
access into two, or we have a non-power-of-two block size).

> No production filesystem on Linux has checksums (well, ext4
> has a few). Of the ones that add checksumming, I'd say most will not do
> data checksumming (and for direct IO it is not done).
>    

I believe btrfs checksums direct IO.  Unfortunately it has some way to 
go before it can be used in production.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

