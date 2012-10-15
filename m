Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2JOQGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:06:19 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17288 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2JOQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:06:15 -0400
Message-ID: <1350317173.3452.9.camel@lorien2>
Subject: Re: WARNING: at lib/dma-debug.c:948 check_unmap()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourcefor..." <e1000-devel@lists.sourceforge.net>,
        shuahkhan@gmail.com
Date: Mon, 15 Oct 2012 10:06:13 -0600
In-Reply-To: <20121014170226.GA3235@localhost>
References: <20121014170226.GA3235@localhost>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 01:02 +0800, Fengguang Wu wrote:
> Hi Shuah,
> 
> FYI, your debug commit
> 
> commit 224d4b5563b005836628b1c02ebe374684df118f
> Author: Shuah Khan <shuah.khan@hp.com>
> Date:   Fri Oct 12 15:23:05 2012 +1100
> 
>     dma-debug: new interfaces to debug dma mapping errors
> 
> triggers the below warning. Hopefully you know better than me the real
> issue and relevant developers to CC.
> 

This warning indicates that the driver failed to check dma mapping error
on a buffer returned by dma_map_single() or dma_map_page() call. Looking
at the the area where mapping is done, it appears it does call
dma_mapping_error(). It does allocate several buffers in a loop, so it
not obvious to me why the warning is showing up. I will follow-up on
this to make sure it is not a false alarm, before I get the driver team
involved. Thanks for reporting it.

-- Shuah

