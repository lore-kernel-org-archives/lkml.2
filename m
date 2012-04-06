Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2DFUQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:16:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46579 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2DFUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:16:04 -0400
Date: Fri, 6 Apr 2012 23:16:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120406201601.GA3310@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
 <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
 <4F7F1659.5090305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7F1659.5090305@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 09:14:17AM -0700, H. Peter Anvin wrote:
> On 04/06/2012 02:54 AM, Alexey Dobriyan wrote:
> > 
> > I agree, this particular changelog may be somewhat out of line.
> > 
> > But I find it little hypocritical that kernel developers add CONFIG_PROC_FS,
> > fix compilation problems associated with it, do not mount proc by default,
> > do not mark it unmountable somehow and
> > then say procless setups aren't worth it.
> > 
> 
> Aren't worth *optimizing for*.  But yes, CONFIG_PROC_FS is pretty much a
> historic relic at this point, and probably should just be dropped.

What to do with automounting /proc so it availablility would match
syscall availability?

> > Without proc knowledge about fdtable is gathered linearly and still unreliable.
> > With nextfd(2), even procful environments could lose several failure branches.
> 
> What?  Please explain how on Earth this would "lose several failure
> branches."

closefrom(3) written via nextfd(2) loop is reliable and doesn't fail.
closefrom(3) written via /proc/self/fd is reliable and can fail (including ENOMEM).
closefrom(3) written via close(fd++) is unreliable.

If programmer adds nextfd(2) loop before any closefrom(3) code
he currently uses, there will be less failures.
