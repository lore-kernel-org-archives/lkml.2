Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0KKKeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:34:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab0KKKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:34:17 -0500
Date: Thu, 11 Nov 2010 11:34:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] tracing - fix recursive user stack trace
Message-ID: <20101111103415.GD18718@basil.fritz.box>
References: <20101110164413.GA5360@nowhere>
 <1289466549-7602-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289466549-7602-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:09:08AM +0100, Jiri Olsa wrote:
> The user stack trace can fault when examining the trace. Which
> would call the do_page_fault handler, which would trace again,
> which would do the user stack trace, which would fault and call
> do_page_fault again ...
> 
> Thus this is causing a recursive bug. We need to have a recursion
> detector here.

I suspect this problem is in more trace points: any NMI or MCE 
trace point or any other trace point that can be triggered
from a page. so it seems to be a general bug fix independent
of the other patch.

-Andi
