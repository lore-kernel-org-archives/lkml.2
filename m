Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0FVGHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:07:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39296 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab0FVGHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:07:53 -0400
Message-ID: <4C205323.3010509@zytor.com>
Date: Mon, 21 Jun 2010 23:07:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
References: <20100612060322.29053.94187.reportbug@feather> <1276351120.14011.194.camel@localhost> <4C13D1E7.7060604@zytor.com> <20100612185538.GA4511@feather> <4C13F102.7000509@zytor.com> <20100612222634.GA1785@feather> <4C141214.5050601@zytor.com> <20100613000742.GA3469@feather> <4C14235B.7030605@zytor.com> <20100622052236.GA9130@feather>
In-Reply-To: <20100622052236.GA9130@feather>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 10:22 PM, Josh Triplett wrote:
> 
> How might I diagnose this further?  What might cause Linux to refuse to
> use the e820 and e801 results provided by GRUB, but accept the ones
> provided by the BIOS?
> 

This is interesting... you apparently have a ACPI 3-style e820 BIOS as
evidenced by the [1] markers, but Grub presents it as legacy style.
Now, the kernel shouldn't care, but this at least gives a clue.

Something that might be worthwhile is to add printf's to the kernel's
e820-parsing routine (in arch/x86/boot/e820.c) and figure out why it
doesn't like the output.  It's a bit strange that meminfo would produce
sensible-looking output (well, legal, at least; presenting a two-byte
range is rather beyond crazy, and so forth) and the kernel wouldn't
accept it, as the code is intentionally very similar.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

