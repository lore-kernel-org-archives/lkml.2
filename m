Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2LYDSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 22:18:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56087 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2LYDSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 22:18:40 -0500
Date: Mon, 24 Dec 2012 19:18:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121225031835.GD10220@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
 <20121224183334.GB11817@htj.dyndns.org>
 <20121224185555.GA5344@liondog.tnic>
 <20121224190723.GE11817@htj.dyndns.org>
 <20121224193258.GB5344@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121224193258.GB5344@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Borislav.

On Mon, Dec 24, 2012 at 08:32:58PM +0100, Borislav Petkov wrote:
> Ok, understood. I have only one question: how do you make sure
> schedule_work() is used only in cold paths?

Hot and cold are relative terms and unless someone is doing things
like invoking queue_work() from high-frequency interrupt handler, the
level of overhead from queue_work() isn't likely to matter.  The best
way to deal with such hot paths would differ depending on the
specifics of each hot path - ie. bouncing to workqueue from IRQ
handler would be better handled by threaded IRQ handlers.

At this point, especially given how all of work_pending() users are
way too cold for any of this to matter, I don't think we need to worry
about this.

> Btw, there's __cancel_delayed_work() which is not used anywhere and it
> could be deleted AFAICT.

Yeah, there are several interfaces which are being deprecated.
They'll be gone in a few cycles.

Thanks.

-- 
tejun
