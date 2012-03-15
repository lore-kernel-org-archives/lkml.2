Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031397Ab2COAeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:34:12 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10400 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab2COAeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:34:09 -0400
Date: Thu, 15 Mar 2012 01:33:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] mpi: Avoid using freed pointer in mpi_lshift_limbs()
In-Reply-To: <CALLzPKbAGKL-o66UmWJ4uGSmA1TymdCQA0CfBajHLVYzt_60UA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1203150130370.22671@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net> <alpine.LNX.2.00.1203012232480.19443@swampdragon.chaosbits.net> <CALLzPKbAGKL-o66UmWJ4uGSmA1TymdCQA0CfBajHLVYzt_60UA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Kasatkin, Dmitry wrote:

> On Thu, Mar 1, 2012 at 11:33 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> >
> > Ping?
> >
> > On Mon, 6 Feb 2012, Jesper Juhl wrote:
> >
> >> At the start of the function we assign 'a->d' to 'ap'. Then we use the
> >> RESIZE_IF_NEEDED macro on 'a' - this may free 'a->d' and replace it
> >> with newly allocaetd storage. In that case, we'll be operating on
> >> freed memory further down in the function when we index into 'ap[]'.
> >> Since we don't actually need 'ap' until after the use of the
> >> RESIZE_IF_NEEDED macro we can just delay the assignment to it until
> >> after we've potentially resized, thus avoiding the issue.
> >>
> >> While I was there anyway I also changed the integer variable 'n' to be
> >> const. It might as well be since we only assign to it once and use it
> >> as a constant, and then the compiler will tell us if we ever assign to
> >> it in the future.
> >>
> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >> ---
[...]
> Hello,
> 
> I was travelling last week.
> I will review the patch now..
> 

:-) Thanks. No rush, I'd just like to see the fix included at some point 
if you agree that it is correct - just wondered at the "~1 month no 
response".


> Thanks,
> Dmitry
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

