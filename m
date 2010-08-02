Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0HBSyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:54:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49476 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0HBSyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H1oNyzgX+hJg0jfGb7k9s8X96gKf0njAiMskORZU59taW2XVXl1OtHG+FGEkKEJNkq
         EaTCJbYFq7nEvXOKAgdYHHa+M/h1N6No+P19J2e0JmVhti3aHjqxVGhrdw5dJqUmhAws
         yoH/Qg4n9nHioN5/mpPZxUbu2QdIuqG66kfbk=
Date: Mon, 2 Aug 2010 22:54:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from
	compressed/misc.c
Message-ID: <20100802185410.GE5544@lenovo>
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5710C1.8020809@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 11:38:57AM -0700, H. Peter Anvin wrote:
> On 08/02/2010 10:49 AM, Cyrill Gorcunov wrote:
> > On Mon, Aug 02, 2010 at 02:18:39AM -0700, Yinghai Lu wrote:
> >>
> >> will get
> >>
> >> |Decompressing Linux... Parsing ELF... done.
> >> |Booting the kernel.
> >>
> >> in serial console.
> >>
> >> reuse code from arch/x86/boot/
> >> and we can use printf if needed
> >>
...
> > 
> > It seems eventually we just add ~80 lines of code in compare with what we had before,
> > just to print "Decompressing..." by serial line. Not sure Yinghai if it worth
> > it. Though having printf that early might be quite useful for those who debugging
> > or developing new compressors/decompressors. If it would be small non-intrusive
> > patch I would both hands for it but now I simply don't know (to be fair mine
> > proposal based on your initial patch not better either ;)
> > 
> 
> Decompressing... is one thing, and if it was only that, I'd just suggest
> killing off the console I/O in boot/compressed.  Getting an error
> message out when there is a decompression failure is another thing.
> 
> Processing the command line a novo is somewhat painful, but it does deal
> better with bootloaders that use the 32-bit entry point by necessity
> (kexec, EFI) or due to sheer stupidity (Grub2).
> 
> As such, I think it's a worthwhile addition, as long as the source code
> can be cleanly shared with the boot/ directory.
> 
> 	-hpa
> 

ok, fair enough, I just don't like nesting *.c inclusion you know but seems
it would be the only more-less clean way here.

	-- Cyrill
