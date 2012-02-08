Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2BHJxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:53:21 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45616 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2BHJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:53:19 -0500
Date: Wed, 8 Feb 2012 15:10:09 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v10 3.3-rc2 1/9] uprobes: Install and remove
 breakpoints.
Message-ID: <20120208094009.GB24443@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120202141840.5967.39687.sendpatchset@srdronam.in.ibm.com>
 <20120202141851.5967.68000.sendpatchset@srdronam.in.ibm.com>
 <20120207171707.GA24443@linux.vnet.ibm.com>
 <CAK1hOcOd3hd31vZYw1yAVGK=gMV=vQotL1mRZkVgM=7M8mbMyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK1hOcOd3hd31vZYw1yAVGK=gMV=vQotL1mRZkVgM=7M8mbMyw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020809-7408-0000-0000-0000027C6954
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko <vda.linux@googlemail.com> [2012-02-08 10:40:30]:

> On Tue, Feb 7, 2012 at 6:17 PM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
> > Changelog: (Since v10): Add code to clear REX.B prefix pointed out by Denys Vlasenko
> > and fix suggested by Masami Hiramatsu.
> ...
> > +       /*
> > +        * Point cursor at the modrm byte.  The next 4 bytes are the
> > +        * displacement.  Beyond the displacement, for some instructions,
> > +        * is the immediate operand.
> > +        */
> > +       cursor = uprobe->insn + insn_offset_modrm(insn);
> > +       insn_get_length(insn);
> > +       if (insn->rex_prefix.nbytes)
> > +               *cursor &= 0xfe;        /* Clearing REX.B bit */
> 
> It looks like cursor points to mod/reg/rm byte, not rex byte.
> Comment above says it too. You seem to be clearing a bit
> in a wrong byte. I think it should be


Oh okay, Will correct this and send out a new patch.


> 
>         /* Clear REX.b bit (extension of MODRM.rm field):
>          * we want to encode rax/rcx, not r8/r9.
>          */
>         if (insn->rex_prefix.nbytes)
>                 insn->rex_prefix.bytes[0] &= 0xfe;

-- 
Thanks and Regards
Srikar

