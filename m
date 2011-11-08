Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1KHItt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:49:49 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:12972 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1KHItr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:49:47 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH v2] Input: convert obsolete strict_strtox to kstrtox
In-Reply-To: <87vcqv838n.fsf@emc.com.tw>
References: <1320666890-29615-1-git-send-email-jj_ding@emc.com.tw> <20111108035930.GC21927@core.coreip.homeip.net> <20111108062800.GA1837@core.coreip.homeip.net> <87vcqv838n.fsf@emc.com.tw>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 08 Nov 2011 16:47:25 +0800
Message-ID: <87sjlz80gy.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Nov 2011 15:47:36 +0800, JJ Ding <jj_ding@emc.com.tw> wrote:
> On Mon, 7 Nov 2011 22:28:01 -0800, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > On Mon, Nov 07, 2011 at 07:59:30PM -0800, Dmitry Torokhov wrote:
> > > 
> > > Applied, thanks JJ.
> > > 
> > 
> > Sorry, I take it back...
> > 
> > > -       if (strict_strtoul(buf, 10, &value) || value > 1)
> > > +       if (kstrtouint(buf, 10, &value) || value > 1)
> > >                 return -EINVAL;
> > 
> > This mangles error condition from kstrtouint and reporting conditions
> > beside -EINVAL was the reason for introducing new API IIRC. The proper
> > conversion should be:
> > 
> > 	err = kstrtouint(buf, 10, &value);
> > 	if (err)
> > 		return err;
> > 
> > 	if (value > 1)
> > 		return -EINVAL;
> > 
> > Thanks.
> > 
> 
> Thanks, I get it. I'll fix and resend.
> 
> jj
> 

Thinking a bit more about your suggestion, and looking at the code more
closely, some uses of these conversions really want a u8, and some want a
bool. I think I should check the data type where these converted values
are really used, and use a more appropriate kstrtox.

And for those that just need a bool, do you think using strtobool
introduced in commit d0f1fed29e6e73d9d17f4c91a5896a4ce3938d45 OK?
That way the user may even type [NnYy01].

What do you think about the approach above?

Thanks,
jj

> > -- 
> > Dmitry
