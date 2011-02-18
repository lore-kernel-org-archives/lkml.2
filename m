Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1BRHoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:44:07 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36842 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1BRHoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:44:04 -0500
Date: Fri, 18 Feb 2011 08:44:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
Message-ID: <20110218074401.GA26836@merkur.ravnborg.org>
References: <4D5DB83D.80205@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5DB83D.80205@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 10:07:25AM +1000, Greg Ungerer wrote:
>
> Hi All,
>
> I would like to put up for discussion a merge of the m68knommu and
> m68k arch branches.
>
> Attached is a script and patch that does a kind of brute force
> simplistic merge of the directories and files. (Thanks to Stephen King
> <sfking@fdwdc.com> for the initial version of this script, and to
> Sam Ravnborg for the m68k includes merge script this was based on).
> Nothing outside of the arch/m68k and arch/m68knommu directories is
> touched, and in the end there is no more arch/m68knommu. To apply you
> simply run the script from the top of a current kernel git tree (I used
> 2.6.38-rc5 for testing) and then apply the patch.

The initial version of said script was created by Arnd IIRC.

> Thoughts?
When we merged x86, sh and sparc in the past this has in all
cases helped sharing coe between the 32 and 64 bit variants.
There has in all cases been some code-chrunch in the beginning,
but the result has been good.
What as often caused some troubles has been how to configure
the individual architectures.

We have for eaxample:
make ARCH=x86, make ARCH=i386, make ARCH=x86_64 today.

Likewise for sparc we have:
make ARCH=sparc, make ARCH=sparc32, make ARCH=sparc64

So you need to consider how to deal with this for m68k.
Maybe MMU is just an option so you only have ARCH=m68k in the end?

You do not touch upon the maintenance of the merged trees.
Today there is different maintainers for the two archs.
To have a transparent flow the better solution is likely that
all m68k* patches go via one of your trees so we do not
have two trees that deal with m68k upstream.

I assume we will sort it all out naturally and I hope that
we soon will have m68k and m68knommu merged!

	Sam
