Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2LMXss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:48:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40744 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab2LMXsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:48:47 -0500
Message-ID: <50CA6918.5060806@zytor.com>
Date: Thu, 13 Dec 2012 15:47:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v6 00/27] x86, boot, 64bit: Add support for loading ramdisk
 and bzImage above 4G
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are obviously good bits to this patchset, but I'm really starting 
to think the "pseudo-linear mode" via a trap handler -- meaning we can 
access all of memory without any extra effort -- makes more sense.  In 
fact, that way we could just build the full page tables without worrying 
about incremental bootstrap, depending on if that is a complexity win or 
not.

Either way, this is for native only: the Xen domain builder or other 
similar entry paths should be setting up page tables that cover all of 
memory; I'm hoping Konrad and Stefano can confirm this.

The only reason to go with another approach I can think of is if it 
makes 32/64-bit unification cleaner.

	-hpa

