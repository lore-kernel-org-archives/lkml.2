Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1BBQws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:52:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42781 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1BBQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FwYTy4zirfzGZu68tBHSUlECauT3zeGo9AueIS5d/jQW+q4MRf/WherY/yfD3eAS90
         3vNQmrr7Vsz4ZnTTJ9dlPLHz16MMgMNspSL78bCZSD1eJjOVZRNViGdyUKEZjqMAKrF0
         2taWXzdKoithG2xuPN4nbcxAm1DL3ug3j5F4Q=
Date: Wed, 2 Feb 2011 08:52:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc3: FUSE (sshfs) hangs under load
Message-ID: <20110202165236.GA3178@core.coreip.homeip.net>
References: <20110201175452.GB518@core.coreip.homeip.net>
 <E1PkbGG-0005Rf-QL@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PkbGG-0005Rf-QL@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 12:52:36PM +0100, Miklos Szeredi wrote:
> On Tue, 1 Feb 2011, Dmitry Torokhov wrote:
> > Hi,
> > 
> > After installing 2.6.38-rc3 (plus a few input patches) sshfs started to
> > misbehave on me under load. It starts off fine but when I try to compile
> > a few modules against kernel sources residing on the other box the
> > processes go into 'D' state and just sit there doing nothing.
> 
> Can you please post a stack trace from SysRq-T?
> 

Will do tonight. In the meantime I tried bisecting, but failure is not
always triggered on the first attempt so results are iffy. The log so
far:

# bad: [7d44b0440147d83a65270205b22e7d365de28948] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
git bisect start '7d44b0440147d83a65270205b22e7d365de28948' 'v2.6.37'
# bad: [84b7290cca16c61a167c7e1912cd84a479852165] Merge git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6
git bisect bad 84b7290cca16c61a167c7e1912cd84a479852165
# good: [fea9294c5f2902c45613681ad995ca27899d2016] pch_can: Optimize "if" condition in rx/tx processing
git bisect good fea9294c5f2902c45613681ad995ca27899d2016
# bad: [c96e96354a6c9456cdf1f150eca504e2ea35301e] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6 into for-davem
git bisect bad c96e96354a6c9456cdf1f150eca504e2ea35301e
# good: [003ea98195eebdfcf476317b517e8c29a25b9d10] iwlwifi: remove reference to Gen2
git bisect good 003ea98195eebdfcf476317b517e8c29a25b9d10

The last good must have been also bad as sshfs got stuck while I was
installing next bisect step over it.

Thanks.

-- 
Dmitry
