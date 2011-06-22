Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab1FVTH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:07:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60042 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab1FVTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:07:25 -0400
Message-ID: <4E023D3E.1090408@zytor.com>
Date: Wed, 22 Jun 2011 12:06:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nancy Yuen <yuenn@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, rick@vanrein.org, rdunlap@xenotime.net,
        Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>	<20110622110034.89ee399c.akpm@linux-foundation.org>	<4E0230CD.1030505@zytor.com> <BANLkTinMrMcDw8KX3BxmZh12-kULmecT-s9gdRGpYUCfNjFO7Q@mail.gmail.com>
In-Reply-To: <BANLkTinMrMcDw8KX3BxmZh12-kULmecT-s9gdRGpYUCfNjFO7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 12:01 PM, Nancy Yuen wrote:
> 
> Good point.  There's the MAX_NODES that expands it, though it's still
> hard coded, and as I understand, intended for NUMA node entries.  We
> need anywhere from 8K to 64K 'bad' entries.  This creates holes and
> translates to twice as many entries in the e820.  We only want to
> allow this memory if it's needed, instead of hard coding it.
> 

It should be dynamic, probably.  We can waste memory during early
reclaim, but the memblock stuff should be dynamic.

	-hpa
