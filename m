Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2IZWdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:33:41 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:59748 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2IZWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:33:40 -0400
Message-ID: <506382B0.8040908@cs.tu-berlin.de>
Date: Thu, 27 Sep 2012 00:33:20 +0200
From: =?ISO-8859-1?Q?=22Jan_H=2E_Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120324 Thunderbird/10.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
References: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de> <20120926211526.GA30261@kroah.com>
In-Reply-To: <20120926211526.GA30261@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2012 23:15, schrieb Greg Kroah-Hartman:
> On Wed, Sep 26, 2012 at 07:58:45PM +0200, Jan H. Schönherr wrote:
>> Against v3.6-rc7, only lightly tested.
> 
> Well, against linux-next and highly tested would be best.  It's a bit
> late to get this into linux-next for 3.7, how important is it really?

There are no conflicting commits in linux-next, so it should apply there
as well.

"Tested" as in: it fixes my use case: multiple printk()s shortly after each
other -- with KERN_prefix but without a newline at the end. Those were
sometimes concatenated since that printk-rewrite.

All other printk()s that I come across more often look as usual, before and
after the patch. (Mostly singular printk()s, but I also checked the output
from the oom-killer.)

There is no need to include this hastily -- at least not from my point of view
-- as it is already broken in 3.5 and nobody else seems to notice it
(... and I have now a fix for my development printk()s). Should I resend the
patch later?

I was also hoping that Kay might share his opinion, as the LOG_CONT
flag is rather young, and he might have some different plans for it.

(And of course, some more testing wouldn't hurt.)

Regards
Jan



