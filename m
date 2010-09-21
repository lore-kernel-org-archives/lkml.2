Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0IUEXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:23:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55201 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0IUEXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:23:21 -0400
Date: Tue, 21 Sep 2010 01:10:39 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org
Subject: Re: Possible regression with skb_clone() in 2.6.36
Message-ID: <20100921041039.GA8978@vigoh>
References: <1283209824-8795-1-git-send-email-padovan@profusion.mobi>
 <20100917153440.474b93e4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917153440.474b93e4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2010-09-17 15:34:40 -0700]:

> On Mon, 30 Aug 2010 20:10:23 -0300
> "Gustavo F. Padovan" <padovan@profusion.mobi> wrote:
> 
> > I've been experiencing some problems when running the L2CAP Streaming mode in
> > 2.6.36. The system quickly runs in an Out Of Memory condition and crash. That
> > wasn't happening before, so I think we may have a regression here (I didn't find
> > where yet). The crash log is below.
> 
> So 2.6.35 was OK?
> 
> > The following patch does not fix the regression, but shows that removing the
> > skb_clone() call from l2cap_streaming_send() makes the problem goes away. The
> > patch is good anyway since it saves memory and time when sending Streaming mode
> > packets.
> 
> How does "make it go away" differ from "fix the regression" :)
> 
> But yes, if we don't understand the source of the bug then it may well
> still be there.  Did you make any progress in understanding the cause?

I did some progress and found that this really fix the bug. We are fine
here then. :)

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
