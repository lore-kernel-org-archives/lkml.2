Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1CUU2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:28:51 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18897 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1CUU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:28:50 -0400
Date: Mon, 21 Mar 2011 21:28:41 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Andreas Schwab <schwab@linux-m68k.org>
cc: linux-kernel@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH][RFC] HPFS: Don't use pointer to out-of-scope array
In-Reply-To: <alpine.LNX.2.00.1101062306080.13988@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1103212128350.15815@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012242020090.28973@swampdragon.chaosbits.net> <m2mxnuew8a.fsf@whitebox.home> <alpine.LNX.2.00.1012242139450.28973@swampdragon.chaosbits.net> <alpine.LNX.2.00.1101062306080.13988@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Jesper Juhl wrote:

> On Fri, 24 Dec 2010, Jesper Juhl wrote:
> 
> > On Fri, 24 Dec 2010, Andreas Schwab wrote:
> > 
> > > Jesper Juhl <jj@chaosbits.net> writes:
> > > 
> > > > Secondly I fail to see how this code inside the while loop can even work:
> > > >
> > > >   if (hpfs_ea_read(s, a, ano, pos + 4, ea->namelen + 1 + (ea->indirect ? 8 : 0), ex + 4))
> > > >
> > > > There is nothing initializing 'ex' which 'ea' points to, so 
> > > > 'ea->namelen' and 'ea->indirect' are uninitialized.
> > > 
> > > The preceding hpfs_ea_read should do it (it reads the first 4 bytes of
> > > ex which aliases ea->namelen and ea->indirect).
> > > 
> > How I managed to miss that I don't know, but I did and you are correct. 
> > Thanks.
> > 
> But, this bit: "in the 'while (pos < len)' loop a local char array 'ex' is 
> defined and subsequently the pointer variable 'ea' is set to point to the 
> array. Inside the loop we may jump to the 'indirect' label which is 
> outside the loop scope. At the 'indirect' label 'ea' (which now points 
> to a array that is no longer in scope) is dereferenced - that's not good. 
> The patch below addresses that problem by moving the 'ex' array out of 
> the loop scope and into function scope."
> I still believe to be correct and that's what the patch actually 
> addresses, so can we agree that the patch makes sense and should be 
> merged?
> 
Ping? 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

