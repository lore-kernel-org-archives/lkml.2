Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3AJLgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:36:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab3AJLgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:36:19 -0500
Date: Thu, 10 Jan 2013 11:36:16 +0000
From: Mel Gorman <mgorman@suse.de>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] Add decoder for GFP masks to tools.
Message-ID: <20130110113616.GG13304@suse.de>
References: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:24:13PM -0800, Cody P Schafer wrote:
> I needed to decode some gfp_masks to debug an oom-killer invocation, and wrote
> this tool to avoid doing the decoding manually.
> 
> Bad things about this: slightly hacky use of code intended for use with ftrace,
> splitting linux/gfp.h into 2 parts.
> 
> Good things: No additional places need modification to keep the decoder up to
> date, no mistakes from manual gfp_mask decoding.
> 

Any particular reason you did not use scripts/gfp-translate?

$ bash ./scripts/gfp-translate 0x1000d0
Source: /home/mel/git-public/linux-2.6
Parsing: 0x1000d0
#define ___GFP_WAIT		0x10
#define ___GFP_IO		0x40
#define ___GFP_FS		0x80
#define ___GFP_KMEMCG		0x100000

Script is dumb as rocks, requires access to the source code and does not
translate flag combinations into something like GFP_KERNEL but it's usually
sufficient. I'm not pushed either way but if you want to push your tool
then the patch should also delete scripts/gfp-translate.

-- 
Mel Gorman
SUSE Labs
