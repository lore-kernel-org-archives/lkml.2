Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0JYPS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:18:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab0JYPSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <4CC5B8D3020000780001EFB4@vpn.id2.novell.com>
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com> <20101025140218.5092.74117.stgit@warthog.procyon.org.uk>
 <28707.1288018465@redhat.com> <4CC5B8D3020000780001EFB4@vpn.id2.novell.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Oct 2010 08:17:12 -0700
Message-ID: <AANLkTi=mpKRQgZp5zCoCsBtkuWHrpkOq2Zch-OOGu4CC@mail.gmail.com>
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers
 in brackets
To: Jan Beulich <JBeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 8:05 AM, Jan Beulich <JBeulich@novell.com> wrote:
>
> Alexander, you seem to be having access to a worst case system -
> could you give this a try?

This all seems very wrong.

The whole "add parenthesis" seems to break several architectures
(Power apparently had problems too due to redefining one of the
macros), and it is ugly.

And the whole thing was added for some stupid gas bug for a very
specific case, and now we're adding _more_ crap to an already ugly
workaround.

How about just removing the idiotic workaround entirely, and then on
x86 passing "-traditional" to cpp for asm input so that it doesn't add
spaces in argument expansion? Make the workaround more targeted to the
actual problem, rather than working around it in some unrelated
thing..

                                       Linus
