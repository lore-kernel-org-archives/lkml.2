Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0CQLY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:24:28 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:57604 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab0CQLY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:24:27 -0400
Date: Wed, 17 Mar 2010 07:22:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Roland Dreier <rdreier@cisco.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kfifo:  possible weird violation of what should be invariant
In-Reply-To: <adamxy79a5u.fsf@roland-alpha.cisco.com>
Message-ID: <alpine.LFD.2.00.1003170720060.5960@localhost>
References: <alpine.LFD.2.00.1003151702040.3329@localhost> <adamxy79a5u.fsf@roland-alpha.cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Roland Dreier wrote:

>  >   sure, the code seems to work, but allowing the internal values of a
>  > kfifo to contain invalid values on a regular basis would seem to make
>  > a mess of, say, tracing or debugging.  making sure that offset values
>  > actually lie within their valid range would seem to be one of those
>  > ASSERT() things that should always be true, should it not?  is there a
>  > reason the design is like this?
>
> Actually I believe having the values be free-running without
> clamping them makes the code much simpler -- the reason being that
> you preserve the invariant of "in" always being ahead of "out".  If
> you reduce the pointers modulo the size, then you end up having a
> lot of code that has two cases: one to handle "in > out", and one to
> handle "in < out because in has wrapped and out hasn't yet".

  yes, i see your point.  so, as i read it, the internal kfifo "in"
and "out" pointers are *never* actually normalized modulo the buffer
size, which means that, at any time, you can easily check how much
*total* data has gone through the kfifo.  potentially useful.  perhaps
there should be a comment or note to that effect stuffed in there
somewhere as some kernel programmers might find that handy, who knows?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
