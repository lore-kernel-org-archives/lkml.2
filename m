Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab1EXXH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:07:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52436 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab1EXXH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:07:26 -0400
Message-ID: <4DDC39F1.2060903@zytor.com>
Date: Tue, 24 May 2011 16:06:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <20110524211644.GJ27634@elte.hu>
In-Reply-To: <20110524211644.GJ27634@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 02:16 PM, Ingo Molnar wrote:
> 
> On some systems holes can be pretty low as well - you'd have to research e820 
> maps submitted to lkml to see how common this is - but it's not terribly 
> common.
> 
> Some really old systems might have a hole between 15MB-16MB - but that's not an 
> issue if we load at 16 MB or higher.
> 

It definitely happens, and not just at 15-16 MiB either.

Doing this without actually consulting the memory map is dangerous as
hell; plus you have to verify that you're not clobbering anything else,
like the command line, initramfs or the linked list of data.

	-hpa
