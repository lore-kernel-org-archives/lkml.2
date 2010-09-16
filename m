Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0IPGdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:33:49 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41906 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab0IPGds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:33:48 -0400
Message-ID: <4C91BA4B.5040501@kernel.dk>
Date: Thu, 16 Sep 2010 08:33:47 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: Re: linux-next: build warning after merge of the final tree (block
 tree  related)
References: <20100916150101.3ced35b9.sfr@canb.auug.org.au>
In-Reply-To: <20100916150101.3ced35b9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 07:01, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig with CONFIG_DEBUG_SECTION_MISMATCH=y) produced this warning:
> 
> WARNING: init/mounts.o(.text+0x21a): Section mismatch in reference from the function name_to_dev_t() to the function .init.text:match_dev_by_uuid()
> The function name_to_dev_t() references
> the function __init match_dev_by_uuid().
> This is often because name_to_dev_t lacks a __init 
> annotation or the annotation of match_dev_by_uuid is wrong.
> 
> Introduced by commit b5af921ec02333e943efb59aca4f56b78fc0e100 ("init: add
> support for root devices specified by partition UUID").

match_dev_by_uuid() should not be __init, I'll fix that up.

-- 
Jens Axboe

