Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1A0NeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:34:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62352 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1A0NeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:34:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ja3bENF/OiZCaKokaSdTthQq9hF9bxdiTE/tZUblweqkHYSyHZa4Mi1/iwFLF+b61o
         dLUO7IplhQkiigpRuKKklpcFlp1ieNsX4eGuBQwfbDODIoB9/DQ71gKxpeL/6MVmZQlr
         Bom5RD1BgHWC/05DBSFnOOneSsrkjpKrG7gZc=
Date: Thu, 27 Jan 2011 14:34:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 2/4] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
Message-ID: <20110127133412.GC24925@htj.dyndns.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
 <1293016398-18001-3-git-send-email-tj@kernel.org>
 <20110117221340.E6A4F180996@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117221340.E6A4F180996@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 17, 2011 at 02:13:40PM -0800, Roland McGrath wrote:
> Of course I agree that the current code is wrong here.  But I'm still not
> at all clear on what practical compatibility problems it introduces.  This
> change is OK if and only if we are really making the only area clean and
> well-defined in the same release cycle.

I don't follow what you meant by the above sentence.  Can you please
clarify a bit?

> It doesn't really matter that the old behavior was ill-defined and
> unreliable in absolute terms, because the practical userland
> experience of it in real-world cases is what userland has grown to
> expect.  We can't break any such expectations until we have a clear
> answer about how to solve the problems correctly.

It's slightly more serious than that.  Calling wake_up_process()
unconditionally can cause a quite serious failure.  It wakes up a
process in any state and there are code paths which aren't prepared to
be woken up unless certain conditions are met.  A safer choice can be
changing it to wake up only tasks in interruptible sleep.

I have very difficult time imagining what real user visible
implication it would have in negative and noticeable manner, so while
I do agree that we should proceed carefully, I think it would be
better to take the chance and remove the erratic behavior.  We have
release cycles and testing at multiple layers after all.  If we find
out that it breaks something in serious manner, we can always revert.

Thank you.

-- 
tejun
