Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964Ab2EQOkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:40:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760921Ab2EQOkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:40:47 -0400
Date: Thu, 17 May 2012 16:40:32 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Eliminating UDF iocharset!=utf8 code (Re: [PATCH 6/8] Support
 non-BMP characters in UDF)
Message-ID: <20120517144032.GA10676@quack.suse.cz>
References: <4FB2E25E.900@gmail.com>
 <20120516143448.GD27661@quack.suse.cz>
 <4FB3C44F.6080409@gmail.com>
 <20120516200459.GD1687@quack.suse.cz>
 <4FB44856.40102@gmail.com>
 <4FB44AF1.4060103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB44AF1.4060103@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-05-12 02:48:49, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> 
> > I've noticed another duplication in the UDF code: there
> > is NLS support and separate UTF-8 support. UTF-8 is support by 2 ways
> > actually: with -o utf8 and -o iocharset=utf8 which imply different
> > codepaths. Specific UTF-8 support is probably slightly faster by
> > avoiding calls and basically doing everything with shifts (or can be
> > made so with a small patch). Should I perhaps kill one of them? Is
> > iocharset!=utf8 still of any importance? I haven't seen it in ages.
> > Perhaps we could keep just the performant UTF-8 support and map
> > iocharset=utf8 to it and drop iocharset!=utf8? iocharset!=utf8 probably
> > has no users anyway so keeping it we're likely to keep bugs and code
> > duplication with no benefit.
> > 
> 
> Linux seems to support UTF-8-only pretty strongly: http://yarchive.net/comp/linux/utf8.html
> (message from Sun, 15 Feb 2004 02:42:45 GMT).
> And I completely agree.
> If it's ok to kill iocharset!=utf8 I'll propose a series of 3 patches (killing iocharset!=utf8,
> extending utf16toutf8/utf8toutf16 for unaligned input, changing UDF code to use common functions)
  Well, yes, utf8 is currently the only sane setting but that doesn't mean
someone isn't using (e.g. iso8859-2) for strange reasons... We should
regress in user visible functionality only for really good reasons and here
I don't see a strong reason. So I'd like to keep current iocharset mount
option and make utf8 option equivalent to iocharset=utf8. Since I don't
think the speed benefit of dedicated CS0<->UTF8 functions is really that
big and UDF isn't exactly a filesystem where it would matter anyway, I'd
just remove those dedicated functions and use the generic ones instead.

								Honza


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
