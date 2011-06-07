Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1FGILV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:11:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49486 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1FGILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=WTZf+/uFGfwYpZDEfouVac6dg9u42BCGo7U+QdDXjt6QJDwQxin2tToP77ZsHUEWUn
         e5+/Ue2yAOAKCIwTSDlzh6UBpfovdqNXHvCH0844NPBAMScp8MzzNYyk+EPvcbRcTAgW
         rmRONB77uiJ0y+nFQcTG8uCB/jlmsv+LvJAkk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Status of function-sections work?
Date: Tue, 7 Jun 2011 10:11:15 +0200
User-Agent: KMail/1.8.2
References: <20110606011531.GA1887@leaf>
In-Reply-To: <20110606011531.GA1887@leaf>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106071011.15114.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011 03:15, Josh Triplett wrote:
> Hello,
> 
> I found your work in 2010 on using function-sections and data-sections
> to eliminate unused code in the kernel.  I'd like to make use of this
> work to try to build an extremely space-constrained kernel.
> 
> It looks like a few of your patches made it into the kernel, but most of
> the linker script changes don't seem to have made it in.  I wanted to
> find out the status of this work.  Do you still have this working?  Do
> you have versions of your patches for current Linux?

parisc uses ^ in some identifiers. Therefore we need something like
[A-Za-z0-9_$^]* in linker script. This wasn't working with GNU ld -
^ is not a valid char for pattern. Use of more general [!.]*
was also impossible - ! is not a valid char too.

Therefore I asked binutils people to fix this (they agreed) and
decided to wait for a fixed binutils to be released.


> Have you considered re-submitting?

Yes, I need to do this...


-- 
vda

