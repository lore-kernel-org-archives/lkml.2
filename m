Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0I3URl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:17:41 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:58541 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932161Ab0I3URk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:17:40 -0400
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100930200850.GB4120@redhat.com>
References: <1285875804.2180.1.camel@cowboy>
	 <alpine.DEB.2.00.1009301258550.9112@chino.kir.corp.google.com>
	 <20100930200850.GB4120@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 16:17:31 -0400
Message-ID: <1285877851.2180.8.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 16:08 -0400, Dave Jones wrote:
> On Thu, Sep 30, 2010 at 01:02:54PM -0700, David Rientjes wrote:
>   > > index 994230d..db7dc35 100644
>  > > --- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
>  > > +++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
>  > > @@ -379,6 +379,8 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *handle)
>  > >  	if (!(supported & 0x1))
>  > >  		return -ENODEV;
>  > >  
>  > > +	return ret;
>  > > +
>  > >  out_free:
>  > >  	kfree(output.pointer);
>  > >  	return ret;
>  > 
>  > Why is the kfree() unnecessary?  acpi_evaluate_object() will allocate a 
>  > new output.pointer if it returns 0, so at this point in the code you would 
>  > now be leaking the buffer.
>  > 
>  > Instead, it would probably be better to fix the existing memory leaks in 
>  > that function where we return -ENODEV without going to out_free when 
>  > output.length is non-zero.
> 
> Oh, *duh*. That was subtle.

Yep, anyways, at least we got the correct "fix".

> You, and Pekka are of course correct.  I'll merge up Pekka's patch.
> 
> thanks,
> 
> 	Dave
> 
> 


