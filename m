Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0KYHr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:47:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0KYHr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gXKAoSxZ6Kgwv0Z3Jv8Ab/VM7/RmwmFIT8I+jrZqps/Y9g+XyJbD/OlHSwtWtPxoVN
         lpWs+8CSPjDCcrsTa5B6/Em4WU/GrGLvlrOmRjAzd0lvgPWZYCUzIB3DDMiMp0b4h+wS
         NrvD80QXgraqtEF0JCsPxsNra25BQiVMKjDV4=
Date: Thu, 25 Nov 2010 08:47:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "All since 2.6.33.x" <stable@kernel.org>
Subject: Re: [PATCH 1/2] x86: Ignore trap bits on single step exceptions
Message-ID: <20101125074747.GD2538@nowhere>
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
 <1289684273-26770-2-git-send-regression-fweisbec@gmail.com>
 <4CED7642.8070600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED7642.8070600@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:32:02PM +0100, Michael Stefaniuc wrote:
> Hello Frederic,
> 
> On 11/13/2010 10:37 PM, Frederic Weisbecker wrote:
> >When a single step exception fires, the trap bits, used to
> >signal hardware breakpoints, are in a random state.
> >
> >These trap bits might be set if another exception will follow,
> >like a breakpoint in the next instruction, or a watchpoint in the
> >previous one. Or there can be any junk there.
> >
> >So if we handle these trap bits during the single step exception,
> >we are going to handle an exception twice, or we are going to
> >handle junk.
> >
> >Just ignore them in this case.
> >
> >This fixes https://bugzilla.kernel.org/show_bug.cgi?id=21332
> sorry for the delay in testing this.
> 
> I have cherry-picked this patch on top of v2.6.37-rc3-102-gea49b16
> and the ntdll/exception tests pass now.
> 
> Many thanks
> bye
> 	michael

Thanks for testing!
