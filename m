Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0KZPFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:05:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:40489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0KZPFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:05:20 -0500
Message-ID: <4CEFCC85.2020600@kernel.org>
Date: Fri, 26 Nov 2010 16:04:37 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/14] signal: don't notify parent if not stopping	after
 tracehook_notify_jctl() in do_signal_stop()
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-5-git-send-email-tj@kernel.org> <20101126144654.GB28177@redhat.com>
In-Reply-To: <20101126144654.GB28177@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:04:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On 11/26/2010 03:46 PM, Oleg Nesterov wrote:
>> This doesn't cause any behavior difference as the condition never
>> triggers in the current code.
> 
> I don't understand the motivation then (probably I should read
> the next patches).

The thing is that with the further changes in the series
tracehook_notify_jctl() becomes rather pointless as do_signal_stop()
becomes more involved with the ptrace logic and bypasses
tracehook_notify_jctl(), so I'm basically getting it out of the way.

tracehook might not be such a bad idea for parts which are further
away but for parts which are this close to ptrace implementation, it
seems more of obfuscation than helpful layering.  Especially,
restrictions and capabilities of tracehooks without actual (even
proposed) users aren't very healthy to keep.  Other people have to
keep guessing what the intentions behind the unused features are,
which is very frustrating and silly.

Anyways, we can deal with tracehooks later.  Let's just ignore
tracehook related changes for now.

Thanks.

-- 
tejun
