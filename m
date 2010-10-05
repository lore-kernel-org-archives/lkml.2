Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0JESLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:11:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43996 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab0JESK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:10:59 -0400
Message-ID: <4CAB69F3.7030309@zytor.com>
Date: Tue, 05 Oct 2010 11:09:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>,
        akpm@linux-foundation.org, phillip@lougher.demon.co.uk,
        hsweeten@visionengravers.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] initramfs: strcpy destination string overflow
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com> <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com> <AANLkTinoCgO56O1kPNW3vjd9Nd1kY2SU34UH2RQa9qkE@mail.gmail.com> <20101005165159.GQ19804@ZenIV.linux.org.uk>
In-Reply-To: <20101005165159.GQ19804@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 09:51 AM, Al Viro wrote:
> 
> Take a look at struct hash definition.  That sizeof is PATH_MAX and
> do_header() will reject an entry with name longer than that.  IOW,
> the whole thing is a non-issue; we can add
> 	if (strlen(name) >= PATH_MAX)
> 		BUG();
> if we really care, but that's it.
> 
> As a side note, it looks like we need a fat warning about blind "improvements"
> of that kind in CodingStyle; cargo-cult replacements like that can easily
> hide real bugs... ;-/

BUG_ON(strlen(name) >= PATH_MAX);

... would work for me.

OK, not an issue...

	-hpa
