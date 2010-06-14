Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0FNHrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:47:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58195 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0FNHrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=LAY2XBRMg8EiQQ14vIp0y+n/SZn94iZM/bz471WoFhKDnQGEggrqlSaMYrlGEA13vc
         crvQIyNP2kcT/wuasTTRGFfIzo/Y8F8Ew91Mdpk5TaZbMVtmy2fKbFojKSTprKLRuDzF
         eDEtdoPsBxW4GaB0KSGXGUMTSwCg0VOJAeeaI=
MIME-Version: 1.0
In-Reply-To: <1276199568.16089.35.camel@work-vm>
References: <AANLkTinIO5a1EeK6Ej2ljkuyL9zv06OMfbyiZBaxTQTd@mail.gmail.com> 
	<alpine.LFD.2.00.1006092206020.2933@localhost.localdomain> 
	<AANLkTin-6XsW49ECufTLcdzaD1eK9bAxe0j7RXvPqN7p@mail.gmail.com> 
	<1276199568.16089.35.camel@work-vm>
From: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Date: Mon, 14 Jun 2010 00:46:48 -0700
X-Google-Sender-Auth: iCJwvlKdx5pIL465k8xHgD-X7eU
Message-ID: <AANLkTikPwOWHUdqZH1S9QVh-sgjlzptAB27_hK_otQ4Y@mail.gmail.com>
Subject: Re: Timekeeping issue on aggressive suspend/resume
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 12:52 PM, john stultz <johnstul@us.ibm.com> wrote:
> I think Thomas was suggesting that you consider creating a option for
> where CLOCK_MONOTONIC included total_sleep_time.
>
> In that case the *hack* (and this is a hack, we'll need some more
> thoughtful discussion before anything like it could make it upstream)
> would be in timekeeping_resume() to comment out the lines that update
> wall_to_monotonic and total_sleep_time.
>
> It would be interesting to hear if that hack works for you, and we can
> try to come up with a better way to think about how to accommodate both
> views of how to account time over suspend.

Thanks.

I tried this fix. It seemed to help, however the accuracy of sleep
time for the process was not quite right. A process thread which was
supposed to wake up every (X) seconds, seemed to wake up every (X -
delta X) seconds.

Also another side effect of this change was that the system time was
no longer in sync with the wall time.

These problems were more pronounced when the suspend/wakeup cycle time
was brought down to 0.5 seconds from 4 seconds. The periodicity of
most of the process threads were disturbed.

I decided to NOT suspend/resume the timekeeping subsystem in the
kernel and try. It seemed to work. Every application seems to work
fine.

Now my question is; Is it safe to disable suspend/resume of the
timekeeping subsystem? Will it have an effect (on
functionality/performance) which may not surface in my short
experiments?

Thanks in advance,

Suresh
