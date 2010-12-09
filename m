Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0LIQRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:17:12 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57428 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab0LIQRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fCjyAVp+zz+37P3jvNKGviuLoQz7fBGCMamuanU1WZQc34Q/4JMRMYGScF+4aBmA6l
         /qkwK2zp2GONzswJfF3a6D/UMlFN3KHTPG/N0NDo9sXIVJnuwh5icrr5Ci84pGulLhiz
         yX0SVGqfg/Z0WEXN6l/goiSDDTozo6O8b8LsA=
Date: Thu, 9 Dec 2010 19:17:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, penberg@kernel.org
Subject: Re: [PATCH UPDATED#3 04/16] x86: setup_local_APIC() must always be
	called with preemption disabled
Message-ID: <20101209161703.GA13257@lenovo>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org> <4D00B3B9.7060702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D00B3B9.7060702@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 11:47:21AM +0100, Tejun Heo wrote:
> setup_local_APIC() is used to setup local APIC early during CPU
> initialization and already assumes that preemption is disabled on
> entry.  However, The function unnecessarily disables and enables
> preemption and uses smp_processor_id() multiple times in and out of
> the nested preemption disabled section.  This gives the wrong
> impression that the function might be able to handle being called with
> preemption enabled and/or migrated to another processor in the middle.
> 
> Make it clear that the function is always called with preemption
> disabled, drop the confusing preemption disable block and call
> smp_processor_id() once at the beginning of the function.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> ---

Thanks a lot, Tejun!
FWIW
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
