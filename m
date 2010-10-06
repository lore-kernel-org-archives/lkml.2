Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab0JFJCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:02:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33625 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab0JFJCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:02:46 -0400
Subject: Re: [PATCH 1/1] initramfs: strcpy destination string overflow
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: "ext H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, phillip@lougher.demon.co.uk,
        hsweeten@visionengravers.com, linux-kernel@vger.kernel.org
In-Reply-To: <4CAB69F3.7030309@zytor.com>
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <AANLkTinoCgO56O1kPNW3vjd9Nd1kY2SU34UH2RQa9qkE@mail.gmail.com>
	 <20101005165159.GQ19804@ZenIV.linux.org.uk>  <4CAB69F3.7030309@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 12:58:21 +0400
Message-ID: <1286355501.24366.92.camel@ekuznets-lx-nokia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 09:02:01.0085 (UTC) FILETIME=[235842D0:01CB6535]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 11:09 -0700, ext H. Peter Anvin wrote:
> On 10/05/2010 09:51 AM, Al Viro wrote:
> > 
> > Take a look at struct hash definition.  That sizeof is PATH_MAX and
> > do_header() will reject an entry with name longer than that.  IOW,
> > the whole thing is a non-issue; we can add
> > 	if (strlen(name) >= PATH_MAX)
> > 		BUG();
> > if we really care, but that's it.
> > 
> > As a side note, it looks like we need a fat warning about blind "improvements"
> > of that kind in CodingStyle; cargo-cult replacements like that can easily
> > hide real bugs... ;-/
> 
> BUG_ON(strlen(name) >= PATH_MAX);

Should it be:

BUG_ON(strlen(name) >= N_ALIGN(PATH_MAX));


-Evgeny
> 
> ... would work for me.
> 
> OK, not an issue...
> 
> 	-hpa


