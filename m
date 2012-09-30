Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2I3SwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 14:52:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60645 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab2I3SwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 14:52:18 -0400
Message-ID: <506894D5.5060101@zytor.com>
Date: Sun, 30 Sep 2012 11:52:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pierre Beck <mail@pierre-beck.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc7 32-bit PAE miscalculates dirty page limits
References: <5068130A.4050602@pierre-beck.de>
In-Reply-To: <5068130A.4050602@pierre-beck.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 02:38 AM, Pierre Beck wrote:
> Hi,
>
> there seems to be a bug in either ext4 or VM code triggered with 16 GB
> memory when compiled with 32-bit and PAE. dirty_background_ratio
> defaults to 10, dirty_ratio to 20. But in effect, dirty pages are
> strongly limited (zero or negative?). I observed extreme I/O wait states
> and slow disk access. A quick cure was to set dirty_bytes and
> dirty_background_bytes to sane values, overriding the ratios. An
> educated guess: the result of dirty_ratio calculation is stored as an
> unsigned 32-bit integer and overflows?
>

Seriously, why are you running a 32-bit kernel on memory sizes this 
large?  Yes, in theory it should work up to 64 GB but claims are that 
the kernel doesn't even boot if you try...

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

