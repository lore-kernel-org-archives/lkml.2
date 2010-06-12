Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0FLXC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 19:02:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0FLXCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 19:02:55 -0400
Message-ID: <4C141214.5050601@zytor.com>
Date: Sat, 12 Jun 2010 16:02:44 -0700
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
> Everything looks identical except for the region GRUB hooked right below
> the first reserved region; the unhooked version has available memory
> from 0-0x9cbf0, and the hooked version has available memory from
> 0-0x9cba0, then reserved from 0x9cba0-0x9cbec, then 4 bytes of available
> memory, and then the same reserved region as before.
> 

Actually... are both these done by chainloading Grub (with and without
mapping), or is the unhooked done without chainloading Grub at all?

To me it looks like something is chaining INT 15h even in the
"unchained" case...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

