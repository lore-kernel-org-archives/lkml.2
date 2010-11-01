Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab0KATd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:33:59 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21057 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0KATd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:33:56 -0400
Date: Mon, 1 Nov 2010 20:23:23 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Borislav Petkov <bp@alien8.de>
cc: linux-kernel@vger.kernel.org, Peter Oruba <peter.oruba@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        amd64-microcode@amd64.org
Subject: Re: [PATCH] AMD Microcode: Prefer vzalloc() over calls to
 vmalloc()+memset()
In-Reply-To: <20101031100833.GA18633@liondog.tnic>
Message-ID: <alpine.LNX.2.00.1011012020500.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302118160.1572@swampdragon.chaosbits.net> <20101031100833.GA18633@liondog.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010, Borislav Petkov wrote:

> On Sat, Oct 30, 2010 at 09:23:14PM +0200, Jesper Juhl wrote:
> > We don't have to do memset() ourselves after vmalloc() when we have 
> > vzalloc(), so change that in 
> > arch/x86/kernel/microcode_amd.c::get_next_ucode().
> > 
> > Please CC me on replies.
> > 
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> > compile tested only.
> > 
> >  microcode_amd.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> > index e1af7c0..d46e805 100644
> > --- a/arch/x86/kernel/microcode_amd.c
> > +++ b/arch/x86/kernel/microcode_amd.c
> > @@ -183,9 +183,8 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
> >  		return NULL;
> >  	}
> >  
> > -	mc = vmalloc(UCODE_MAX_SIZE);
> > +	mc = vzalloc(UCODE_MAX_SIZE);
> >  	if (mc) {
> > -		memset(mc, 0, UCODE_MAX_SIZE);
> >  		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
> >  				   total_size)) {
> >  			vfree(mc);
> 
> Good.
> 
> Better yet, you can go a step further and remove one indentation block:
> 
> --
> 	mc = vzalloc(UCODE_MAX_SIZE);
> 	if (!mc)
> 		goto out;
> 
> 	if (get_ucode_data(mc, ...
> 	...
> 
> out:
> 	return mc;
> 
> }
> --
> making the code even fit in 80 chars width and thus more readable.
> 
> Thanks.
> 
Thank you for the feedback I'll prepare a new version of the patch 
incorporating it, then resend it. 

One thing I'm not entirely sure about though is how to credit you with 
your improment to my original patch. Would I simply prepend

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Borislav Petkov <bp@alien8.de>

or should I leave just my own Signed-off-by: and then mention you in the 
changelog part of the mail or? 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

