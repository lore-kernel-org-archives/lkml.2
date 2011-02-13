Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1BMRh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 12:37:59 -0500
Received: from mail.codesourcery.com ([38.113.113.100]:39746 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1BMRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 12:37:53 -0500
Date: Sun, 13 Feb 2011 17:37:50 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Petr Baudis <pasky@suse.cz>
cc: "H.J. Lu" <hjl.tools@gmail.com>, Florian Weimer <fw@deneb.enyo.de>,
        x32-abi@googlegroups.com, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 psABI status
In-Reply-To: <20110213163556.GH13985@machine.or.cz>
Message-ID: <Pine.LNX.4.64.1102131729120.16193@digraph.polyomino.org.uk>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
 <87aai1gdr7.fsf@mid.deneb.enyo.de> <4D5711E0.7020306@zytor.com>
 <87r5bcnwvw.fsf@mid.deneb.enyo.de> <AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
 <87tyg8j7le.fsf@mid.deneb.enyo.de> <AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
 <20110213163556.GH13985@machine.or.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011, Petr Baudis wrote:

> I think it would be great if you could add some text like this plus some
> rationale (AIUI, this is geared mainly at new Atoms and other x86_64
> embedded platforms) to the document.
> 
> (BTW, it is not really convincing to me that such a niche is worth all
> the trouble this is going to bring.)

It seems to me there's a much more general utility for this.  After all, 
the normal practice on 64-bit Power Architecture GNU/Linux systems, say, 
is for most programs to be 32-bit and only a few that have a use for a 
large address space to be 64-bit.  For most programs, large pointers and 
size_t are just a waste of memory (and so of cache) - but the extra 
registers are significantly beneficial (as are such things as being able 
to assume SSE to be supported).  (Large files, 64-bit time_t, etc., 
however, are of wider use than large address space, but as I noted in 
<http://gcc.gnu.org/ml/gcc/2010-12/msg00509.html> it would be a fairly 
substantial project to address all such issues of inappropriate arbitrary 
limits in C APIs.)

-- 
Joseph S. Myers
joseph@codesourcery.com
