Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1BNNEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:04:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62850 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1BNNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rop4UxcTgcgZmfKqLRK1IALyeA+wnDDMw+oByqwxbk7cK7cFpaiz3IBmUl9cIl6Ce9
         h30KNVP0EeQpnnXWAB+Hjk4ttprl604CBjanOtFFPk6vxc9tKB2LHQW5f50SEcCdPixf
         8T9U2KexI4HEv2ybJSz0n2xhtqmJaU1p4LvUQ=
Date: Mon, 14 Feb 2011 14:03:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Ray Jui <rjui@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Questions about Linux workqueue in 2.6.36
Message-ID: <20110214130300.GH18742@htj.dyndns.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C2EAC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110209102847.GE3770@htj.dyndns.org>
 <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C3163@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C3163@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 09, 2011 at 02:38:36PM -0800, Ray Jui wrote:
> You are right. The problem with the rescuer is that when it is
> leaving a gcwq, it does not check to see whether it needs to wake up
> a worker to process subsequent work items. After applying your
> patch, I see pid 26 getting waken up by the rescuer and work items
> from mmc1 and mmc2 are now being processed properly.

Cool, I'll send the patch to upstream and stable.

> I also did a quick profiling on the amount of time it takes to
> create a new worker on our system. It takes 15 ~ 20 ms. This is not
> surprising as it's an embedded system and it was during kernel boot
> up and the system was getting quite busy. Regardless, the current 10
> ms initial mayday timeout has resolution issues on a lot of embedded
> systems with worse timer resolutions (e.g., 10 ms on our system).

Can you please verify the second patch removes the unncessary rescuer
invocation?

Thanks.

-- 
tejun
