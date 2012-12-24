Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2LXTdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 14:33:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab2LXTdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 14:33:02 -0500
Date: Mon, 24 Dec 2012 20:32:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121224193258.GB5344@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
 <20121224183334.GB11817@htj.dyndns.org>
 <20121224185555.GA5344@liondog.tnic>
 <20121224190723.GE11817@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121224190723.GE11817@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 11:07:23AM -0800, Tejun Heo wrote:
> And that's broken. It seems trivial but it really isn't and trying to
> optimize things like that in cold paths is just a bad idea. Not enough
> people will pay attention to them and they will stay subtly broken for
> a very long time. So, having "not doing anything in code which isn't
> necessary in code" as priority in cold paths is likely to hurt you.
> A better one would be "doing straight-forward and simple thing with
> acceptable overhead".

Ok, understood. I have only one question: how do you make sure
schedule_work() is used only in cold paths?

Btw, there's __cancel_delayed_work() which is not used anywhere and it
could be deleted AFAICT.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
