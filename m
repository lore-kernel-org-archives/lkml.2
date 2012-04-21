Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2DUIh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 04:37:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51200 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DUIhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 04:37:24 -0400
Message-ID: <4F9271BF.4000302@openvz.org>
Date: Sat, 21 Apr 2012 12:37:19 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: fix integer overflow in MS_NOUSER definition
References: <20120421054949.32549.2823.stgit@zurg> <20120421062838.GS6871@ZenIV.linux.org.uk>
In-Reply-To: <20120421062838.GS6871@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Sat, Apr 21, 2012 at 09:49:49AM +0400, Konstantin Khlebnikov wrote:
>> MS_NOUSER defined as signed int (1<<31), sb->s_flags declared as unsigned long.
>> So (sb->s_flags&  MS_NOUSER) works as (sb->s_flags&  0xffffffff80000000).
>
> ... and it's not a problem since we can't use bits 32 and above anyway -
> unsigned long is 32bit on a lot of platforms.  I have no objections to
> making that 1U<<31, but it's not a bug, let alone an integer overflow.

Yes, it's not a bug here, but I not sure about the rest thousand places, where
similar expressions are used. Probably checkpatch should warn about such things.

BTW this patch makes code smaller =)

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-16 (-16)
function                                     old     new   delta
graft_tree                                   135     119     -16
