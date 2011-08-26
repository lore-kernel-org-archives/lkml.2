Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab1HZO1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:27:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1HZO1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:27:32 -0400
Date: Fri, 26 Aug 2011 16:27:21 +0200
From: Tejun Heo <tj@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, containers@lists.osdl.org,
        Andi Kleen <andi@firstfloor.org>, Nathan Lynch <ntl@pobox.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110826142721.GG2632@htj.dyndns.org>
References: <20110825170705.GA6387@sun>
 <20110825205426.GO2803@mtj.dyndns.org>
 <20110825211213.GP2803@mtj.dyndns.org>
 <20110825213459.GA1929@sun>
 <20110825213931.GR2803@mtj.dyndns.org>
 <20110826112943.GI3903@sun>
 <20110826122851.GA25853@shutemov.name>
 <20110826131620.GM3903@sun>
 <20110826140620.GE2632@htj.dyndns.org>
 <20110826142334.GA26675@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826142334.GA26675@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 26, 2011 at 05:23:34PM +0300, Kirill A. Shutemov wrote:
> On Fri, Aug 26, 2011 at 04:06:20PM +0200, Tejun Heo wrote:
> > > +struct map_files_info {
> > > +	struct file	*file;
> > > +	unsigned char	name[16+16+2]; /* max: %016lx-%016lx\0 */
> > > +	unsigned long	len;
> > > +};
> > 
> > That's slightly above 50 bytes.
> 
> We can use 4 * sizeof(unsigned long) + 2 for name to save a bit on 32 bit
> architectures.

Ooh, I wasn't trying to say it was too big.  I was trying to say it
would be okay to have that on stack.  :)

> BTW, show_map_vma() uses "%08lx-%08lx" to print ->start, ->end. I think
> it's good idea to use this here as well to be consistent with
> /proc/$PID/{s,}maps

I'm not too sure about this one.  First of all, I think %08lx is more
of an accident than intention (just forgot to update it while
transitioning to 64bit) and when ls'd the output can be a bit messy
without leading 0's, but again my opinion here isn't very strong.

Thanks.

-- 
tejun
