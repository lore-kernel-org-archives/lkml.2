Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1BPQxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:53:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1BPQxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:53:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RFTnhwU3kzt6c6ntiZBCwwYmplEJLcqRQdlIfVsyT/wTvHNyb2VmSJl4pT8i500rvH
         FChYpRyn/Mq/B6CkBxoGgqFfYinBBpR0rngoYAzTc/FUwotizwU1pdb/DD4NaqIDlE2b
         /NV6gkg5tKLzjwNAZTcKpV8spWS0sfOf/tKk8=
Date: Wed, 16 Feb 2011 17:52:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Ray Jui <rjui@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Questions about Linux workqueue in 2.6.36
Message-ID: <20110216165255.GJ19830@htj.dyndns.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C2EAC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110209102847.GE3770@htj.dyndns.org>
 <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C3163@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110214130300.GH18742@htj.dyndns.org>
 <8628FE4E7912BF47A96AE7DD7BAC0AADDDF03CDD8A@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF03CDD8A@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 15, 2011 at 09:57:21AM -0800, Ray Jui wrote:
> Regarding your second patch, which changes the initial mayday timeout to
> MAYDAY_INITIAL_TIMEOUT	= HZ / 100 >= 2 ? HZ / 100 : 2,
> 
> That's a minimum of 2 timer ticks, which is 20 ms in our
> system. Since the timer resolution in our system is 10 ms and it
> takes 15 ~ 20 ms to create a new kworker during kernel startup in
> our system, I verified that I need to change the minimum timer tick
> to 3 for the rescuer NOT to kick in our system during startup.

I think calling rescuers in that case is not perfect but okay.  It'll
only happen while the level of workers is below stable level.  It
would still be better to avoid calling in rescuers almost immediately
with 0 or 1 jiffy timeout.

Thanks.

-- 
tejun
