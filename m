Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1JKP6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:58:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51365 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab1JKP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:58:12 -0400
Subject: Re: [PATCH] x86, efi: Calling __pa() with an ioremap'd address is
 invalid
From: Matt Fleming <matt@console-pimps.org>
To: "hpanvin@gmail.com" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <ming@elte.hu>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
In-Reply-To: <df88dc7c-e404-4190-a15c-4c3ef44ed45f@email.android.com>
References: <1318337645-7112-1-git-send-email-matt@console-pimps.org>
	 <20111011130333.GA4117@srcf.ucam.org>
	 <1318338617.4060.109.camel@mfleming-mobl1.ger.corp.intel.com>
	 <df88dc7c-e404-4190-a15c-4c3ef44ed45f@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 16:58:09 +0100
Message-ID: <1318348689.4060.118.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 08:45 -0700, hpanvin@gmail.com wrote:
> I think ioremap_cache() should work for either.

Sorry yeah, it will work but I don't think it's desirable (that's what I
meant, though I realise it's not what I wrote).

The reason being: aren't you doing an extra step of indirection because
you have to jump through the vmalloc space?

With 32-bit this is obviously necessary because of the lack of space for
the direct kernel map, but on 64-bit we can just extend the kernel map
and do quick conversions between physical and virtual space with __va()
and __pa().

Maybe the extra indirection isn't that bad and no one will care? If so,
then sure, a unified version sounds like a plan. I was just hesitant of
changing the existing 64-bit implementation for fear of receiving
replies like "you've now made the 64-bit path slower".

-- 
Matt Fleming, Intel Open Source Technology Center

