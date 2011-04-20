Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1DTPDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:03:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35731 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1DTPDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yGL45sQc8VAHc071PIQr/6rSW3oD72kiqZMzzS+dvj5RzfKmZtVXH2puyft/DxGNr9
         Q3mZUc7Gzpr/t+tEjZTNgQhtWD9x2bRfB1stVEvfbdlERR3yKjKJP8oQX8+NFKQkCYH9
         4wiID5I9CvF1TTGIW8PuIMfqu0LFC02wIWAGw=
Message-ID: <4DAEF5A6.4040405@gmail.com>
Date: Wed, 20 Apr 2011 19:03:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf, nmi: Move LVT un-masking into irq handlers
References: <1303145815-15050-1-git-send-email-dzickus@redhat.com> <4DAEEF96.4070807@gmail.com> <20110420145754.GT20887@redhat.com>
In-Reply-To: <20110420145754.GT20887@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 06:57 PM, Don Zickus wrote:
> On Wed, Apr 20, 2011 at 06:37:10PM +0400, Cyrill Gorcunov wrote:
>> Don, sorry for delay, I somehow missed this patch at first place :/ And probably
>> the patch below could help with "stess" problem?
> 
> The patch I am using for the 'stress' problem is different than what I
> posted because I wanted to keep it simple for 2.6.39.  But yeah I already
> moved the unmasking to the enable_pmus_all(0) line.

ok

> 
> The thing is that cuts down on some of these in-flight NMIs but not all of
> them.  I came up with some logic that catches all the in-flight NMIs on
> Nehalem and AMDs but my core2quad still fails.  I'll try to post that
> today while requesting help.

ok

> 
> Still not sure you need the double APIC writes (as your patch) shows.  I
> haven't seen a case in my testing where a single APIC write fails.

yup, we can drop it, thanks!

> 
> Cheers,
> Don

-- 
    Cyrill
