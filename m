Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0I3UI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab0I3UIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:08:55 -0400
Date: Thu, 30 Sep 2010 16:08:51 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Davidlohr Bueso <dave@gnu.org>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
Message-ID: <20100930200850.GB4120@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Davidlohr Bueso <dave@gnu.org>, cpufreq@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <1285875804.2180.1.camel@cowboy>
 <alpine.DEB.2.00.1009301258550.9112@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009301258550.9112@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 01:02:54PM -0700, David Rientjes wrote:
  > > index 994230d..db7dc35 100644
 > > --- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
 > > +++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
 > > @@ -379,6 +379,8 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *handle)
 > >  	if (!(supported & 0x1))
 > >  		return -ENODEV;
 > >  
 > > +	return ret;
 > > +
 > >  out_free:
 > >  	kfree(output.pointer);
 > >  	return ret;
 > 
 > Why is the kfree() unnecessary?  acpi_evaluate_object() will allocate a 
 > new output.pointer if it returns 0, so at this point in the code you would 
 > now be leaking the buffer.
 > 
 > Instead, it would probably be better to fix the existing memory leaks in 
 > that function where we return -ENODEV without going to out_free when 
 > output.length is non-zero.

Oh, *duh*. That was subtle.
You, and Pekka are of course correct.  I'll merge up Pekka's patch.

thanks,

	Dave

