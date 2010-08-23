Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0HWFOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 01:14:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50512 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0HWFOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 01:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hvC45NLAzMeBUeWj6RqBGMuuhMgTpcA8NNRkuYz6PnbOJhoLekeYSaC9ANG6w+N9y+
         STi4LO3o5DViZI/dp7faphb9sYoDDHGm4H4NInpj18qdBOri31GyeSkEI1thPhBakDOj
         XsjG9dXBfVq0M8HJc3NhkwyTe8B2uYVT0xxg0=
Subject: Re: help needed with EXPORT_SYMBOL
From: Aijaz Baig <aijazbaig1@gmail.com>
Reply-To: aijazbaig1@gmail.com
To: netfilter-devel@vger.kernel.org, jengelh@medozas.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1282373834.4080.79.camel@aijazbaig1-desktop>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 10:44:08 +0530
Message-ID: <1282540448.4080.86.camel@aijazbaig1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Yeah I do understand that part, but there has to be a way to do what I
am trying to do here isn't it?

And can anyone tell me can kallsyms_lookup() be used in such a
situation? If yes than how do I use it?

Regards,
Aijaz 

On Sat, Aug 21, 2010 at 2:53 PM, Jan  Engelhardt <jengelh@medozas.de>
wrote:
On Saturday 2010-08-21 08:57, Aijaz Baig wrote:
        
>So why is it that when my netfilter module is exporting something to
>the kernel and im tryin to use it from within a core kernel file, the
>compiler flags a 'undefined reference to' error?
        
There, you answered yourself. Exports only go one way. And that is
core -> module -> module.

On Sat, 2010-08-21 at 12:27 +0530, Aijaz Baig wrote:
> Hello,
> 
> Ive been trying to EXPORT a SYMBOL from a netfilter module (actually a
> hook) to the KERNEL. Various modules seem to export various symbols to
> the kernel (or so it seems), an example being x_tables which exports a
> whole lot of functions like xt_register_target and so on and all other
> netfilter modules which use these functions dont seem to have any
> problems.
> 
> So why is it that when my netfilter module is exporting something to the
> kernel and im tryin to use it from within a core kernel file, the
> compiler flags a 'undefined reference to' error?
> 
> I googled and came to the conclusion from the kernelnewbies mailing list
> that using kallsyms_lookup() seems to be the answer or is it?
> So, if I do intend to use kallsyms_lookup how do I use it? There aren't
> so many instances of it being used it seems.
>  
> Ive seen it being used in dev/core.c like so:
> symname = kallsyms_lookup((unsigned long)sym, &symsize,&offset,&modname,
> namebuf);
> 
> I am basically trying to call a function that MY module EXPORTs inside
> one of the core linux routines. This would also mean that my netfilter
> module must be compiled (and linked also maybe?..not so sound with link
> time stuff) before the address becomes visible so that kallsyms_lookup
> can find it. So do I really shd be using it and if so, how?
> 
> Any input is appreciated.
> 
> Regards,
> Aijaz Baig.
> 
> 



