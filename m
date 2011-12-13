Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1LMXrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:47:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52247 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab1LMXrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:47:16 -0500
Message-ID: <4EE7E3F5.1020700@zytor.com>
Date: Tue, 13 Dec 2011 15:47:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Brian Gerst <brgerst@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, tim@klingt.org
Subject: Re: [PATCH] x86: Split off mem*io functions
References: <CAMzpN2jiZn3=Og9EVhnWbEhZkvi6eebEJpR7qYn00OyJnZgcFQ@mail.gmail.com> <1323641436-12249-1-git-send-email-brgerst@gmail.com> <CA+55aFx37CgDoZeJzxQpsk14yZAzt0g69VtJx=Upj=FBUpCPQw@mail.gmail.com>
In-Reply-To: <CA+55aFx37CgDoZeJzxQpsk14yZAzt0g69VtJx=Upj=FBUpCPQw@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 02:58 PM, Linus Torvalds wrote:
> 
>  - some devices (for example, traditional CGA/VGA) read and write to
> different banks and bit modes, so a "read-mask-write" operation just
> does not work at all. You have to do pure writes when copying to such
> a destination. Afaik, none of our *current* memory copies do this for
> partial words, but it's an example of something that is valid (and
> sometimes done) in memcpy to avoid unaligned stores, for example.
> 

VGA is even weirder: in some modes (which noone in their sane mind use)
you can make it do operations versus an internal buffer.  The catch is
that the internal buffer is only 8 bits wide, so anything other than
byte writes will fail in the extreme in those modes.

	-hpa

