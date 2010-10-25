Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0JYPF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:05:29 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:45129 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab0JYPF2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:2>);
	Mon, 25 Oct 2010 11:05:28 -0400
Message-Id: <4CC5B8D3020000780001EFB4@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 25 Oct 2010 16:05:23 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Cc: "Ingo Molnar" <mingo@elte.hu>, <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, <torvalds@osdl.org>,
        "David Howells" <dhowells@redhat.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h
	 numbers in brackets
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com>
 <20101025140218.5092.74117.stgit@warthog.procyon.org.uk>
 <28707.1288018465@redhat.com>
In-Reply-To: <28707.1288018465@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.10.10 at 16:54, David Howells <dhowells@redhat.com> wrote:
> Jan Beulich <JBeulich@novell.com> wrote:
> 
>> Isn't this a gas bug then? Anywhere you use a plain number you
>> should also be permitted to use an expression.
> 
> Whoever defined the gas assembly syntax for binutils specified that (N) as 
> an
> operand defines an absolute address and N defines an immediate value.
> 
> However, prefixing an expression with a unary plus works for me, so adding
> this into my patch:
> 
> -	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
> +	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 +(\2) /* \3 */:; \
> 
> Does that work for you?

Alexander, you seem to be having access to a worst case system -
could you give this a try?

Thanks, Jan

