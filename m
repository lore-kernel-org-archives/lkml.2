Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2LOBRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:17:01 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:60642 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2LOBRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:17:00 -0500
Message-ID: <50CBCF83.30700@us.ibm.com>
Date: Fri, 14 Dec 2012 17:16:51 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH] time: create __getnstimeofday for WARNless calls
References: <20121119182616.GA4557@www.outflux.net> <CAGXu5jKdOsBUwZRwOQDeRdFjo-K=uEQdJNMgy4N1dyzrUGcAHw@mail.gmail.com>
In-Reply-To: <CAGXu5jKdOsBUwZRwOQDeRdFjo-K=uEQdJNMgy4N1dyzrUGcAHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121501-7408-0000-0000-00000B0D2877
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 10:17 AM, Kees Cook wrote:
> John, any feedback on this?
>
Sorry, yea, I've been meaning to get back to this.

I'm still on the fence about just making getnstimeofday() safe for when 
timekeeping is suspended, but at the same time, your issue needs 
fixing.  Also bailing out at the end still seems off to me. Even if 
someone is using the values despite the WARN_ON, they really are getting 
junk values, and for all the time that WARN_ON has been there, you're 
the first to report running into it.

Even so, I think I'm ok with this patch for now, but I suspect we may 
want to rework it later.

Looking at my inbox, I actually can't find a copy of this specific 
patch. Do you mind bouncing it to me, so I have something I can apply?

Should this also get marked for -stable?

thanks
-john

