Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab2JSLkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:40:16 -0400
Received: from plane.gmane.org ([80.91.229.3]:40506 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2JSLkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:40:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alon Ziv <alon@nolaviz.org>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
Date: Fri, 19 Oct 2012 10:46:50 +0000 (UTC)
Message-ID: <loom.20121019T124226-687@post.gmane.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <507F848F.50707@zytor.com> <CAKgNAki+KV=Nh8D3La50uXpWv7PA5T-oPYJwK-PkOv5vMg0AqA@mail.gmail.com> <508011AD.5080307@zytor.com> <87a9vjp5d9.fsf@rustcorp.com.au> <5080C100.2090703@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 194.90.198.244 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.11 (KHTML, like Gecko) Ubuntu/12.04 Chromium/20.0.1132.47 Chrome/20.0.1132.47 Safari/536.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa <at> zytor.com> writes:
> > It is a bit more indirect, but also in practice it's a bit trickier than
> > that.  We need to ensure the memory doesn't change underneath us and
> > stays attached to that fd.  I can easily see that code slipping and
> > ending in an exploit.
> >
> > But that may be my irrational fear of the mm :)
> 
> You have to do the same thing with a file/file descriptor, I would think.
> 
> However, I keep wondering about the use case for this, as opposed to 
> signatures.

Two things:
1. finit_module() lets LSMs make decisions based on full information on the
   module to be loaded
2. On some systems (such as Chromium OS) we have a trusted root OS (e.g. the
   entire root filesystem is protected using dm-verity); requiring signatures
   on top of this is a waste of resources


