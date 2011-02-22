Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1BVRXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:23:03 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64257 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab1BVRXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z7d7Wf2GH8NwxhLfev/Wk25VIo0a7At6ysfm7iIdauXCvdmoi9zj+F4KpZ3xcRgLQp
         bXmKQfAsfwbogizEcUY6aVjGV65nbb3oNNLOvdFnZFpI9wXK7UtpItH6/tGUyznvREKQ
         8GOZivYmEDbnlnJtbZQjuch53epRRJjQlzkj8=
Date: Tue, 22 Feb 2011 09:22:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "pantherchen@versanet.de" <pantherchen@versanet.de>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
Message-ID: <20110222172254.GA13114@core.coreip.homeip.net>
References: <4D62CE9C.7090806@versanet.de>
 <20110222081752.GP31267@htj.dyndns.org>
 <20110222085223.GC11681@core.coreip.homeip.net>
 <20110222090255.GR31267@htj.dyndns.org>
 <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com>
 <4D63D062.3040404@versanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D63D062.3040404@versanet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 04:04:02PM +0100, pantherchen@versanet.de wrote:
> On 02/22/2011 10:15 AM, Dmitry Torokhov wrote:
> >I'd like to see rc6 tried.
> 
> Unfortunately it shows the same behavior [0]. (To speed things up, I
> used a stripped down kernel config [1], while the first two posted
> boot charts used Ubuntu's stock kernels.)
> 
> I was surprised that the kernel directly built from the wq branch
> and the last "good" kernel from Linus' tree with the 33 patches
> applied don't show the increased boot time - shouldn't they all be
> the same?
> 

No, because there were more merges between your last-known-good (which
is somewhere in the middle of Jiri's HID merge) and Tejun's workqueue
pull. Namely there was merge of my tree that changed serio from using
kseriod to the common workqueue.

Just to confirm, if you revert commit

	8ee294cd9def0004887da7f44b80563493b0a097

from 2.6.38-rc6, does this restore boot time?

-- 
Dmitry
