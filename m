Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0FMAH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 20:07:59 -0400
Received: from relay2-v.mail.gandi.net ([217.70.178.76]:40226 "EHLO
	mrelay2-v.mgt.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752828Ab0FMAH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 20:07:58 -0400
X-Greylist: delayed 8535 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jun 2010 20:07:58 EDT
X-Originating-IP: 217.70.178.44
X-Originating-IP: 74.107.143.84
Date: Sat, 12 Jun 2010 17:07:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
Message-ID: <20100613000742.GA3469@feather>
References: <20100612060322.29053.94187.reportbug@feather>
 <1276351120.14011.194.camel@localhost>
 <4C13D1E7.7060604@zytor.com>
 <20100612185538.GA4511@feather>
 <4C13F102.7000509@zytor.com>
 <20100612222634.GA1785@feather>
 <4C141214.5050601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C141214.5050601@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 04:02:44PM -0700, H. Peter Anvin wrote:
> On 06/12/2010 03:26 PM, Josh Triplett wrote:
> > 
> > Everything looks identical except for the region GRUB hooked right below
> > the first reserved region; the unhooked version has available memory
> > from 0-0x9cbf0, and the hooked version has available memory from
> > 0-0x9cba0, then reserved from 0x9cba0-0x9cbec, then 4 bytes of available
> > memory, and then the same reserved region as before.
> 
> Actually... are both these done by chainloading Grub (with and without
> mapping), or is the unhooked done without chainloading Grub at all?
> 
> To me it looks like something is chaining INT 15h even in the
> "unchained" case...

The "unhooked" case still chainloaded from GRUB, just without calling
drivemap and thus without hooking anything.  I can test without
chainloading from GRUB, though to the best of my knowledge GRUB doesn't
hook int 15 unless it needs to intercept e820 (and e801 and 88).

- Josh Triplett
