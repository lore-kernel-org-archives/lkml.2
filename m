Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab2B2BPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 20:15:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50390 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab2B2BPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 20:15:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F4D7BF9.9070104@jp.fujitsu.com>
Date: Wed, 29 Feb 2012 10:14:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org>
In-Reply-To: <1330445487-15020-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/29 1:11), Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> The idea here is to pass an additional decoded MCE message through
> the tracepoint and into the ring buffer for userspace to consume. The
> designated consumers are RAS daemons and other tools collecting RAS
> information.

I could not catch the point... Why you need this msg field?

I think that all of information about the error is already packed in
the record and that we can make a string from the bits in the record
soon afterward.  From my point of view it seems that what you are
doing here is just consuming the ring buffer by repeating same
contents in another format with dynamic length which might be short
but otherwise could be too long.

And one more unacceptable point is that filling this msg field is
expected to be done in machine check context where have many
limitations in kernel's subsystems such as use of memory allocators.

Suggestion; How about having a kind of translator function for
userland, e.g. an exported function named mce_record_to_msg()?
Tool obtains raw data from the record in the tracepoint's ring buffer,
and if it likes, optionally it can pass the record to the translator
function to get some accomplished string.

> 
> Drop unneeded fields while at it, thus saving some room in the ring
> buffer.

Really unneeded and should be killed? 


Thanks,
H.Seto

