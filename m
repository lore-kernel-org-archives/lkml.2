Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2JAVKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:10:51 -0400
Received: from ozy.pierre-beck.de ([178.63.78.113]:45075 "EHLO
	ozy.pierre-beck.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2JAVKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:10:49 -0400
Message-ID: <506A06B6.50800@pierre-beck.de>
From: Pierre Beck <mail@pierre-beck.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc7 32-bit PAE miscalculates dirty page limits
References: <5068130A.4050602@pierre-beck.de> <506894D5.5060101@zytor.com>
In-Reply-To: <506894D5.5060101@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Original-Recipients: hpa@zytor.com, linux-kernel@vger.kernel.org
X-Original-Date: Mon, 01 Oct 2012 23:10:14 +0200
Date: Mon, 01 Oct 2012 23:10:47 +0200
X-Spam-Notice: Unscanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when I installed the original setup, there were no 64-bit PC CPUs. It's 
been kept up-to-date, changed hardware whenever necessary. But a shift 
from 32-bit to 64-bit isn't as simple as it seems.

I tried 64-bit kernel with 32-bit userspace. It failed. The installed 
DVB-S tuner driver messed up the stream. I *guess* there's some little / 
big endian issue between userspace program (vdr, dvbhddevice) and driver 
(sff716x_ff which is still in experimental media stack), and it *may* be 
resolved by upgrading userspace to 64-bit as well.

I do consider the option of upgrading to 64-bit userspace. My 
distribution Debian doesn't provide a clean way to do so in-place, 
though. There are HOWTOs on the topic with warnings varying between 'do 
not attempt, will eat your data' and 'worked for the author, YMMV'. That 
scared me off for now. Instead, a clean install and copying /etc will be 
my best option and with LVM in place I'm sure I will eventually upgrade 
sooner or later.

Personally, I don't need a fix anyways, since I found the stated 
workaround and can live with that. But what about other folks who 
upgrade their PC? They won't know what hit them when their new PC crawls 
because disk is trashed.

Greetings,

Pierre Beck

On 30.09.2012 20:52, H. Peter Anvin wrote:
> On 09/30/2012 02:38 AM, Pierre Beck wrote:
>> Hi,
>>
>> there seems to be a bug in either ext4 or VM code triggered with 16 GB
>> memory when compiled with 32-bit and PAE. dirty_background_ratio
>> defaults to 10, dirty_ratio to 20. But in effect, dirty pages are
>> strongly limited (zero or negative?). I observed extreme I/O wait states
>> and slow disk access. A quick cure was to set dirty_bytes and
>> dirty_background_bytes to sane values, overriding the ratios. An
>> educated guess: the result of dirty_ratio calculation is stored as an
>> unsigned 32-bit integer and overflows?
>>
>
> Seriously, why are you running a 32-bit kernel on memory sizes this 
> large?  Yes, in theory it should work up to 64 GB but claims are that 
> the kernel doesn't even boot if you try...
>
>     -hpa

