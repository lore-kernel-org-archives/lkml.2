Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0C1ItN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 04:49:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:23005 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0C1ItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 04:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=BkoMxBncWvC2QUKMu9h+ZI10bcW2lCRDEIsXvUmzV2raOxPEr5O+uc6BSsreL6KOFi
         Bw8Ham9pRWZgtr9s0HpicTF3T16kaFQf6XpDpEAPkfvcpazLUkxr2mbVoUvLQz1v3Orh
         Vrha1Vv2ZwXKTMiKNY8RhMqz2ZqWGnfgfmz78=
Message-ID: <4BAF1802.8070002@gmail.com>
Date: Sun, 28 Mar 2010 11:49:06 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: scheduler bug: process running since 5124095h
References: <4BADD408.8080609@gmail.com>
In-Reply-To: <4BADD408.8080609@gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=5379965D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2010 11:46 AM, Török Edwin wrote:
> Hi Ingo, Peter,
> 
> top has just shown me this:
> PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 
>                                                                  6524
> edwin     20   0  228m  10m 8116 R    2  0.3  5124095h gkrellm
> 
> Now obviously that process is not running since 5124095h!
> It looks like some overflow to me, the time in nanoseconds would be
> approx 0xFFFFFE1D2D476000, which is approx. minus 34 minutes.
> Thats about consistent with the uptime, but I don't know why it became
> negative:
>  11:45:48 up 42 min,  9 users,  load average: 0.56, 0.25, 0.19
> 
> I've attached the cfs-debug-info.sh output.
> 
> This happens when using Linux 2.6.33 (actually glisse's drm-radeon tree
> which is based on 2.6.33), its the first time I noticed this.
> 
> I don't know what caused it, the last things I did was:

I have a simple way to reproduce this:
1. Boot the system, run top, confirm everything is normal
2. Run latencytop, and quit (I used version 0.5)
3. Run top, see 5124095h in the TIME column

For example:
 6649 daemon    20   0 74500 8892 3796 S    6  0.2   0:00.03 debsecan
 4255 root      20   0  8908  360  260 S    2  0.0   0:00.04 irqbalance
    1 root      20   0 10332  692  580 S    0  0.0  5124095h init

The processes that get the 5124095h seem random, but there are plenty of
them (if you sort by 'T', the entire top display is filled with
processes running since 5124095h).

Best regards,
--Edwin
