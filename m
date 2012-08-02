Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2HBU3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:29:15 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:50357 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2HBU3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:29:13 -0400
Date: Thu, 2 Aug 2012 22:29:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] kbuild: kvm: make export of linux/kvm_para.h
	unconditional
Message-ID: <20120802202911.GA9108@merkur.ravnborg.org>
References: <1343310254-7493-1-git-send-email-will.deacon@arm.com> <20120802122550.GD9838@mudshark.cambridge.arm.com> <501A8C68.9030001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501A8C68.9030001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 05:19:20PM +0300, Avi Kivity wrote:
> On 08/02/2012 03:25 PM, Will Deacon wrote:
> > On Thu, Jul 26, 2012 at 02:44:14PM +0100, Will Deacon wrote:
> >> The asm-generic version of kvm_para.h is always exported, confusing the
> >> Kbuild wildcarding that tries to detect whether the source architecture
> >> is exporting the header, since asm-* matches the generic version.
> >> 
> >> This patch unconditionally exports linux/kvm_para.h and fixes the few
> >> remaining architectures without asm/kvm_para.h to use the generic
> >> version. I also took the liberty of removing some dead lines from the
> >> wildcarding which was searcing for asm-$(SRCARCH) directores under
> >> $(srctree).
> >> 
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Avi Kivity <avi@redhat.com>
> >> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> Signed-off-by: Will Deacon <will.deacon@arm.com>
> >> ---
> > 
> > Any further comments on this? It fixes header generation for me, so it would
> > be nice to see it merged.
> 
> Can you get it reviewed by someone who is familiar with this?  This is
> probably the third fix for the this issue.

IMO the patch is wrong.
Any use of wildcards in include/asm-generic/Kbuild.asm is wrong.

IMO include/asm-generic/Kbuild.asm is for generic header files
that ALL archs can use.

If not ALL archs can use it, then the individual arch shall
specify the file explicit.

I know we here hit a bad thing with the generic-y support,
where we miss a good way to add a file to a lot of archs
without editing a lot of files.

	Sam
