Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2BVGCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:02:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48443 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab2BVGCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:02:48 -0500
Message-ID: <4F4484F0.9070501@zytor.com>
Date: Tue, 21 Feb 2012 22:02:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: compat: autofs v5 packet size ambiguity - update
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>  <20120221.221609.218135609185671883.davem@davemloft.net>  <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>  <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>  <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com> <1329889428.2193.45.camel@perseus.themaw.net>
In-Reply-To: <1329889428.2193.45.camel@perseus.themaw.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 09:43 PM, Ian Kent wrote:
> 
> However, with the final "char name[NAME_MAX+1]" array at the end, the
> actual size of the structure ends up being not very well defined:
> because the struct isn't marked 'packed', doing a "sizeof()" on it will
> align the size of the struct up to the biggest alignment of the members
> it has.
> 

Note that it's really rather unfortunate that this transmits the entire
packet no matter what, which also means that the "len" field is actually
completely and totally pointless.

I have mentioned in the past that I consider it a design mistake on my
part to have used a pipe in the first place: it was "so easy", but
required an extra read for no good reason, or padding to fixed size
resulting in this problem.  The right thing really should have been to
use a Unix datagram socket; these days using SOCK_SEQPACKET - that way
the kernel would give you the right semantics by design.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

