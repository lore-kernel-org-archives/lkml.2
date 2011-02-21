Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1BUJqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:46:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58850 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1BUJql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qKdRsJhfYWu/deJIcxJ6Wm/UGZxwjBkC7sIXbj2v5D70ml7ZMo+9XyZzo/c8MZyZn+
         nm4Mr9IpVxXbvO7uCzRGXloLQ939SMQqKA+lyzLZg+MM82qZY9b0z9cuO7foDkJWPy1L
         CByRIwK8P/AyeGBITuBziPiQ+BHcSNAgW6FPs=
Date: Mon, 21 Feb 2011 10:46:28 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 3/4] x86, numa: cleanup x86_acpi_numa_init()
Message-ID: <20110221094628.GH31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC18F.2070103@kernel.org>
 <alpine.DEB.2.00.1102191958200.32280@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102191958200.32280@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 08:03:48PM -0800, David Rientjes wrote:
> On Fri, 18 Feb 2011, Yinghai Lu wrote:
> > make it more readable. put valid checking together.
> > 
> > Also restore old acpi_numa_init(). we don't need to touch it
> > because already have x86 own wrapper.
> > 
> > We can limit change to x86 code only.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Acked-by: David Rientjes <rientjes@google.com>

I'm not taking this one.  It's pointless and to me it seems worse.
Why does the function return the count?  What difference do the counts
of 5 and 10 make to the caller?  All it can indicate is failure or
success and 0 and -errno are much better return values for that.

Thanks.

-- 
tejun
