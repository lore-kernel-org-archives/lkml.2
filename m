Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2HOQT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:19:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54461 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495Ab2HOQT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:19:27 -0400
Date: Wed, 15 Aug 2012 20:19:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>
Subject: Re: Q: On restoring terminal with hinted index
Message-ID: <20120815161923.GH23657@moon>
References: <20120815152504.GG23657@moon>
 <502BCB4A.5050002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502BCB4A.5050002@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 09:16:10AM -0700, H. Peter Anvin wrote:
> On 08/15/2012 08:25 AM, Cyrill Gorcunov wrote:
> > Hi Peter,
> > 
> > that happened that in a sake of restoring ptys after checkpoint
> > we need to create them with predefined indices, as they were at
> > moment of dumping. So we have two options -- 1) Open terminals
> > in sequence until needed index reached 2) Use some other way to
> > say the kernel that some index is preferred.
> > 
> > So I thought, would it be acceptible to provide such hint via
> > sysctl, as in patch below (note I've not even compiled it yet,
> > but would like to know your opinion early).
> > 
> > (Maybe even make it one shot, thus once ida_get_new_above called
> >  the pty_next reset to zero).
> > 
> 
> Pardon me while I vomit... an interaction between sysctl and open?  Talk
> about a race condition from hell.  It is stateful, and not connected to
> the filesystem instance that it is supposed to be affecting.  So no,
> please don't.  I understand your objective but it really needs to be
> something attached to the pts filesystem instance in question.

Sure, i'll think on finding some other way to provide such hint to the
kernel.

	Cyrill
