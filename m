Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1KHG2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:28:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33767 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1KHG2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:28:08 -0500
Date: Mon, 7 Nov 2011 22:28:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH v2] Input: convert obsolete strict_strtox to kstrtox
Message-ID: <20111108062800.GA1837@core.coreip.homeip.net>
References: <1320666890-29615-1-git-send-email-jj_ding@emc.com.tw>
 <20111108035930.GC21927@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108035930.GC21927@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 07:59:30PM -0800, Dmitry Torokhov wrote:
> On Mon, Nov 07, 2011 at 07:54:50PM +0800, JJ Ding wrote:
> > From: JJ Ding <dgdunix@gmail.com>
> > 
> > With commit 67d0a0754455f89ef3946946159d8ec9e45ce33a we mark strict_strtox
> > as obsolete. Convert all remaining such uses in drivers/input/.
> > 
> > Also change the data type from long to int as Dmitry sugguests, we now have
> > kstrtouint which suits these uses better.
> > 
> 
> Applied, thanks JJ.
> 

Sorry, I take it back...

> -       if (strict_strtoul(buf, 10, &value) || value > 1)
> +       if (kstrtouint(buf, 10, &value) || value > 1)
>                 return -EINVAL;

This mangles error condition from kstrtouint and reporting conditions
beside -EINVAL was the reason for introducing new API IIRC. The proper
conversion should be:

	err = kstrtouint(buf, 10, &value);
	if (err)
		return err;

	if (value > 1)
		return -EINVAL;

Thanks.

-- 
Dmitry
