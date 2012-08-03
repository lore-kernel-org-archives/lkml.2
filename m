Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2HCMwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:52:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41725 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab2HCMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:51:56 -0400
Date: Fri, 3 Aug 2012 13:51:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] kbuild: kvm: make export of linux/kvm_para.h
 unconditional
Message-ID: <20120803125144.GD26925@mudshark.cambridge.arm.com>
References: <1343310254-7493-1-git-send-email-will.deacon@arm.com>
 <20120802122550.GD9838@mudshark.cambridge.arm.com>
 <501A8C68.9030001@redhat.com>
 <20120802202911.GA9108@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802202911.GA9108@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:29:11PM +0100, Sam Ravnborg wrote:
> On Thu, Aug 02, 2012 at 05:19:20PM +0300, Avi Kivity wrote:
> > Can you get it reviewed by someone who is familiar with this?  This is
> > probably the third fix for the this issue.
> 
> IMO the patch is wrong.
> Any use of wildcards in include/asm-generic/Kbuild.asm is wrong.

I agree that the wildcard stuff is horrible but that's not something
introduced by this patch. In fact, I'm removing those where there is an
asm-generic header that can be used instead.

> IMO include/asm-generic/Kbuild.asm is for generic header files
> that ALL archs can use.
> 
> If not ALL archs can use it, then the individual arch shall
> specify the file explicit.

In which case, we should probably fix the rules for kvm.h and a.out.h as
well. Neither of these headers have asm-generic versions and I doubt this
is possible, so the header-y lines should be done for each architecture
exporting such a header, no?

> I know we here hit a bad thing with the generic-y support,
> where we miss a good way to add a file to a lot of archs
> without editing a lot of files.

If there isn't a generic version of the header, then yes, I guess you have
to modify the architectures that want to export it.

I'm happy to post an extra patch sorting out kvm.h and a.out.h if that's
what's required to get headers building again.

Will
