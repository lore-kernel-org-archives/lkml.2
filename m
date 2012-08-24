Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab2HXKDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:03:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49297 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab2HXKDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:03:13 -0400
Date: Fri, 24 Aug 2012 12:03:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Attilio Rao <attilio.rao@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
Message-ID: <20120824100309.GG3019@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Attilio Rao <attilio.rao@citrix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
	Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com>
 <1345648122-11935-2-git-send-email-attilio.rao@citrix.com>
 <alpine.LFD.2.02.1208231722040.2856@ionos>
 <50364FE5.1070608@citrix.com>
 <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <503664C3.7010301@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 06:13:39PM +0100, Attilio Rao wrote:
> You seriously think that adding a single-check, that will be
> certainly skipped (now), in a boot-time function is going to add any
> performance burden?
> 
> >What you are doing is actively wrong. You suggest that it's fine to
> >call that function with something different than pgt_buf_start as the
> >start argument. That's complete nonsense. The early pages are
> >allocated bottom up beginning at pgt_buf_start. So what the heck would
> >make it sane to change that argument ever?
> 
> If you really don't like this approach, at this point I think the
> best thing to do is to assume that the start address will be
> pgt_buf_start and loose the starting argument at all.
> If you agree I can make a patch for that.

One thing I don't understand is why is xen touching x86 code when it
doesn't have to? At least I cannot find a single reason for it in this
thread.

Thomas is clearly explaining to you that what you're trying to
enforce cannot happen on baremetal x86 and you're still insisting on
"documenting" that.

Here's a simple answer: if it doesn't fix a bug on x86 baremetal (and
you're changing x86 native code only for the sake of xen), there's no
reason wasting energy to create patches.

Thanks.

-- 
Regards/Gruss,
    Boris.
