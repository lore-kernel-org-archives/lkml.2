Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2LZE61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 23:58:27 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:58512 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2LZE6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 23:58:25 -0500
Message-ID: <50DA837A.6040301@synopsys.com>
Date: Wed, 26 Dec 2012 10:26:26 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] Ensure that kernel_init_freeable() is not inlined
 into non __init code
References: <1356072944-23800-1-git-send-email-vgupta@synopsys.com> <20121221072056.GS4939@ZenIV.linux.org.uk> <50D40E82.7000806@synopsys.com>
In-Reply-To: <50D40E82.7000806@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2012 12:53 PM, Vineet Gupta wrote:
> On Friday 21 December 2012 12:50 PM, Al Viro wrote:
>> On Fri, Dec 21, 2012 at 12:25:44PM +0530, Vineet Gupta wrote:
>>> Commit d6b2123802d "make sure that we always have a return path from
>>> kernel_execve()" reshuffled kernel_init()/init_post() to ensure that
>>> kernel_execve() has a caller to return to.
>>>
>>> It removed __init annotation for kernel_init() and introduced/calls a
>>> new routine kernel_init_freeable(). Latter however is inlined by any
>>> reasonable compiler (ARC gcc 4.4 in this case), causing slight code
>>> bloat.
>> Interesting...  I assumed that explicitly set different section would be
>> enough, but I'd been wrong (or the original noinline would've been pointless,
>> now that I think of it).  Consider it ACKed; I can pick it through signal.git,
>> and while it's not urgent I'd send it to Linus after -rc1, with Cc: stable.
>> Or you can send it to him yourself with my usual Acked-by - up to you.
> 
> Merging via your signal.git is fine.
> 
> Thx,
> -Vineet
> 

Hi Al,

Tickled by a spurious mail from "Kbuild test robot" with this change getting
committed into your tree (please see below, which Fengguang acknowledged as a
script error) I took a peek at the commit and it seems the commit log is truncated
when describing the New call chain of kernel_init. If that's too much you might
wanna delete all of the Old vs. New Call chains or preferably restore the "New" part.

Sorry for the nit.

Thx,
-Vineet

-------------->8-------------------------
tree:   git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git for-linus
head:   07570a268090d0a209d957e46d164900999c9e5b
commit: ec21b1033ee6dce41be78c10844f6169566d9d06 [1/6] Ensure that
kernel_init_freeable() is not inlined into non __init code
config: x86_64-randconfig-s542 (attached as .config)

Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
-------------->8-------------------------


