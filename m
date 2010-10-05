Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0JEPzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:55:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab0JEPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:55:53 -0400
MIME-Version: 1.0
In-Reply-To: <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com> <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Oct 2010 08:55:01 -0700
Message-ID: <AANLkTinoCgO56O1kPNW3vjd9Nd1kY2SU34UH2RQa9qkE@mail.gmail.com>
Subject: Re: [PATCH 1/1] initramfs: strcpy destination string overflow
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, phillip@lougher.demon.co.uk,
        hsweeten@visionengravers.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 1:44 AM, Evgeny Kuznetsov
<EXT-Eugeny.Kuznetsov@nokia.com> wrote:
> From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
>
> Function "strcpy()" is used without check for maximum allowed
> source string length and could cause destination string overflow.
> "strcpy()" is replaced by "strlcpy()" to prevent destination
> string overflow.

I think this is wrong.

If the name is too long to fit in the hash table, we should not create
a new hash entry at all, because we'd be returning the wrong
(truncated) name when we find it next time.

So it would be much better to just do

   if (strlen(name) >= sizeof(q->name))
      return NULL;

in find_link(), because as far as I can tell, the hard-linking is
always just an optimization.

Comments? Peter?

                         Linus
