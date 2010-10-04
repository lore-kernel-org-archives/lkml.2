Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0JDHgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:36:36 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:42010 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0JDHgf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 4 Oct 2010 03:36:35 -0400
Message-Id: <4CA9A01B020000780001A509@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 04 Oct 2010 08:36:27 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <heukelum@fastmail.fm>,
        <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org>
 <4C91F07E0200007800016B50@vpn.id2.novell.com>
 <20100916082816.GA25681@elte.hu>
 <4C91F3A30200007800016B64@vpn.id2.novell.com>
 <20100916101355.GA31458@elte.hu>
 <4C9219BC0200007800016C53@vpn.id2.novell.com> <4CA52AA5.5040402@zytor.com>
 <4CA5B7910200007800019F50@vpn.id2.novell.com> <4CA5FC96.1030300@zytor.com>
 <4CA61E8B020000780001A22A@vpn.id2.novell.com> <4CA618AC.4000500@zytor.com>
In-Reply-To: <4CA618AC.4000500@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.10.10 at 19:21, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 10/01/2010 08:46 AM, Jan Beulich wrote:
>> 
>> Perhaps a misunderstanding? I meant to move the % back into
>> movq_cfi's arguments, out of the macro body. pushq_cfi already
>> is in the shape we need for having the option of using cpp macros
>> when !CONFIG_AS_CFI.
>> 
> 
> Hm... I guess I'm not quite following.  I don't really see how that
> would help with movq_cfi, though?

Oh, sorry, I overlooked that the macro is also attaching (%rsp)
to the second operand. So what I said would only apply to
movq_cfi_restore (where \offset really isn't used without the
(%rsp), and hence this can also be moved back out of the macro
body).

For movq_cfi it may require some playing with .irpc to achieve the
same (due to there not being any string manipulation operations
in gas). I'm pretty sure it can be made work, but it'll look ugly
(and/or may require insertion of a space between the offset
expression and the (%rsp)).

Jan

