Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1FVSPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:15:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40416 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab1FVSPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:15:47 -0400
Message-ID: <4E023142.1080605@zytor.com>
Date: Wed, 22 Jun 2011 11:15:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Assmann <sassmann@kpanic.de>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
In-Reply-To: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 04:18 AM, Stefan Assmann wrote:
> 
> The idea is to allow the user to specify RAM addresses that shouldn't be
> touched by the OS, because they are broken in some way. Not all machines have
> hardware support for hwpoison, ECC RAM, etc, so here's a solution that allows to
> use bitmasks to mask address patterns with the new "badram" kernel command line
> parameter.
> Memtest86 has an option to generate these patterns since v2.3 so the only thing
> for the user to do should be:
> - run Memtest86
> - note down the pattern
> - add badram=<pattern> to the kernel command line
> 

We already support the equivalent functionality with
memmap=<address>$<length> for those with only a few ranges... this has
been supported for ages, literally.  For those with a lot of ranges,
like Google, the command line is insufficient.

	-hpa
