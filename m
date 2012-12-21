Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab2LUHYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:24:12 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:45018 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2LUHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:24:02 -0500
Message-ID: <50D40E82.7000806@synopsys.com>
Date: Fri, 21 Dec 2012 12:53:46 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] Ensure that kernel_init_freeable() is not inlined
 into non __init code
References: <1356072944-23800-1-git-send-email-vgupta@synopsys.com> <20121221072056.GS4939@ZenIV.linux.org.uk>
In-Reply-To: <20121221072056.GS4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2012 12:50 PM, Al Viro wrote:
> On Fri, Dec 21, 2012 at 12:25:44PM +0530, Vineet Gupta wrote:
>> Commit d6b2123802d "make sure that we always have a return path from
>> kernel_execve()" reshuffled kernel_init()/init_post() to ensure that
>> kernel_execve() has a caller to return to.
>>
>> It removed __init annotation for kernel_init() and introduced/calls a
>> new routine kernel_init_freeable(). Latter however is inlined by any
>> reasonable compiler (ARC gcc 4.4 in this case), causing slight code
>> bloat.
> Interesting...  I assumed that explicitly set different section would be
> enough, but I'd been wrong (or the original noinline would've been pointless,
> now that I think of it).  Consider it ACKed; I can pick it through signal.git,
> and while it's not urgent I'd send it to Linus after -rc1, with Cc: stable.
> Or you can send it to him yourself with my usual Acked-by - up to you.

Merging via your signal.git is fine.

Thx,
-Vineet
