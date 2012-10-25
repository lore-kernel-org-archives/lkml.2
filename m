Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab2JYAMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:12:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58363 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2JYAMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:12:10 -0400
Message-ID: <508883D6.70706@wwwdotorg.org>
Date: Wed, 24 Oct 2012 18:12:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH 03/23] printk: Move braille console support into separate
 braille.[ch] files
References: <cover.1350449851.git.joe@perches.com> <592f6af296db3e82a392252b3a7c8a7b1020194d.1350449851.git.joe@perches.com>
In-Reply-To: <592f6af296db3e82a392252b3a7c8a7b1020194d.1350449851.git.joe@perches.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 12:06 AM, Joe Perches wrote:
> Create files with prototypes and static inlines for braille
> support.  Make braille_console functions return 1 on success.

Joe,

Between next-20121022 and next-20121023, the serial console (on the ARM
SoC Tegra at least) stopped working. The issue bisects down to this
commit. I haven't had a chance to investigate why yet, I just finished
bisected.

earlyprintk over the same UART works. Once the system has booted, a few
late kernel messages do appear, and then getty/login over the UART
works. So, it's just the printk messages that disappeared.

In case it's relevant, my command-line is:

console=ttyS0,115200n8 loglevel=8 rootwait rw earlyprintk
root=PARTUUID=b2f82cda-2535-4779-b467-094a210fbae7

I'll continue to investigate further tomorrow, but just wanted to give
you a heads-up in case you could immediately see anything obvious in the
code.
