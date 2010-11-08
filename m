Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0KHIE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:04:56 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:55575 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab0KHIEz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 8 Nov 2010 03:04:55 -0500
Message-Id: <4CD7BD310200007800020E13@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 08 Nov 2010 08:04:49 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: more fixes and cleanup to AMD Fam10 MMCONF
	 enabling
References: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
 <4CD4443F.8000008@kernel.org>
In-Reply-To: <4CD4443F.8000008@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.11.10 at 18:51, Yinghai Lu <yinghai@kernel.org> wrote:
> On 11/05/2010 03:59 AM, Jan Beulich wrote:
>> Unfortunately it turned out the original code had more issues: We want
>> to place the region above 4G in any case (even if TOM2 isn't enabled
>> or invalid), and the base mask definition was improperly typed (thus
>> causing shifts by FAM10H_MMIO_CONF_BASE_SHIFT to produce other than
>> the intended result). Fixing this in turn allowed simplifying the MMIO
>> region detection code, as regions ending below TOM2 now aren't of
>> interest anymore.
>> 
>> This will only apply cleanly on top of yesterday's patch titled
>> "x86-64: fix and clean up AMD Fam10 MMCONF enabling".
> 
> I don't think we have systems that have Enable bit set, but TOM2 < 4G.

I suppose that's true, but making the kernel independent of
BIOS flaws (especially when it's that cheap) seems like a good
idea to me. But of course, if that's what would be hindering
acceptance of the patch, I'd re-submit with that part dropped.

Jan

