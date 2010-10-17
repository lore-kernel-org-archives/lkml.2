Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0JQRzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 13:55:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41525 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab0JQRzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 13:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bPGDTMLs/eQgAPppiP55mz3ZUv1GFoSX0uVazJ4c6IW+Bd2NIjbMWtmP68sb1+H/Pn
         rFVIBbEC9KGAjvzaES2ICgeIP3eRDlNGi2aXe95q4b6SfSOI4GxL10+0lEEUOPc9hV/1
         22QXvcHgEFxFbTc1jm8b07JuSBe4/cz3k7MrQ=
Date: Sun, 17 Oct 2010 21:55:34 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] char: synclink: fix information leak to userland
Message-ID: <20101017175534.GA14352@albatros>
References: <1287326493-8134-1-git-send-email-segooon@gmail.com>
 <4CBB177C.9050007@suse.cz>
 <20101017153839.GA11029@albatros>
 <4CBB3667.2010804@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBB3667.2010804@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 19:46 +0200, Jiri Slaby wrote:
> On 10/17/2010 05:38 PM, Vasiliy Kulikov wrote:
> > On Sun, Oct 17, 2010 at 17:34 +0200, Jiri Slaby wrote:
> >> On 10/17/2010 04:41 PM, Vasiliy Kulikov wrote:
> >>> Structure new_line is copied to userland with some padding fields unitialized.
> >>> It leads to leaking of stack memory.
> >>
> >> I think your tool has a bug. I must admit I fail to see the padding
> >> which would cause leaks. Could you elaborate?
> > 
> > I didn't use any tool except "grep copy_to_user" :)
> > 
> >     typedef struct { 
> >         unsigned int clock_rate; /* bits per second */
> >         unsigned int clock_type; /* internal, external, TX-internal etc. */
> >         unsigned short loopback;
> >     } sync_serial_settings;          /* V.35, V.24, X.21 */
> > 
> > On x86_64 sizeof(sync_serial_settings) = 4 + 4 + 2 + 2 = 12.
> > The last 2 is padding.
> 
> Ah, good to know that even end of structures is padded.

The rule here is that array of struct has no padding between struct
elements.  So, struct has padding in the end to have good alignment of
the first field of the next array element.

Thanks,

-- 
Vasiliy
