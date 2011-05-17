Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1EQQ1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:27:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48482 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab1EQQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tjufivp9/I0RhUigPAB0jHbhfEt7wnmStQQzONxW0munmqP+N2LpZTSR2VIxRbjNMf
         Bzzg8f2Og31SGgRYIerEK7MN8X2enl8keL9juHkW37xzEq5hNduATPcJQQL62vy/fz36
         cJDR1BAjroJKa4gPsbN/Rc8LeELnokSbfnQXk=
Date: Tue, 17 May 2011 18:27:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 01/10] signal: remove three noop tracehooks
Message-ID: <20110517162726.GT20624@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-2-git-send-email-tj@kernel.org>
 <20110517162224.GA13675@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517162224.GA13675@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 17, 2011 at 12:22:24PM -0400, Christoph Hellwig wrote:
> On Mon, May 16, 2011 at 08:17:20PM +0200, Tejun Heo wrote:
> > Remove the following three noop tracehooks in signals.c.
> > 
> > * tracehook_force_sigpending()
> > * tracehook_get_signal()
> > * tracehook_finish_jctl()
> > 
> > The code area is about to be updated and these hooks don't do anything
> > other than obfuscating the logic.
> 
> Btw, I think we should kill that stupid <linux/tracehook.h> layer
> entirely.  It consists of a few relatively useful function which should
> just be renamed to ptrace_* and moved to ptrace.c, and a lot of entirely
> pointless wrappers which generally have only a single user, and often
> tons of arguments that aren't actually used.

Yeap, agreed.  It's on the todo list.

Thanks.

-- 
tejun
