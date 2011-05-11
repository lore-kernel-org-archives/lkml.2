Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1EKUV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:21:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48308 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1EKUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tm1LDN9+SwCI2X47d1FUYXAWC/IczBFojTg0/w/VMajdulx25AULaPEU1AO1kax4gb
         avOLQg7kiA17NtAA4vbrI3ji0TXrvSnSnktpNIaH0YC0eIMtZaAun4Qbm6OM0WQibqSy
         JFiuFl/X0UhjTM4SexQpe2XuqzVwzFB5ySbvY=
Date: Wed, 11 May 2011 22:21:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110511202122.GG24245@mtj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110511195824.GA4047@redhat.com>
 <20110511201848.GF24245@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511201848.GF24245@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:18:48PM +0200, Tejun Heo wrote:
> Hmmm... this whole re-trapping thing is turning out to be more
> problematic than expected.  Maybe it would be better to somehow notify
> ptracer directly from prepare_signal().

I need to think more about this but basically we just need to modify
exit_code, last_siginfo and then wake up the parent, all of which can
be done safely while holding child's siglock.  I'll play with it.

Thanks.

-- 
tejun
