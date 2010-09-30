Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0I3UPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:15:42 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:36197 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932088Ab0I3UPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:15:41 -0400
X-Greylist: delayed 1927 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2010 16:15:41 EDT
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>
Cc: davej@redhat.com, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009301258550.9112@chino.kir.corp.google.com>
References: <1285875804.2180.1.camel@cowboy>
	 <alpine.DEB.2.00.1009301258550.9112@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 16:15:32 -0400
Message-ID: <1285877732.2180.7.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 13:02 -0700, David Rientjes wrote:
> On Thu, 30 Sep 2010, Davidlohr Bueso wrote:
> 
> > x86, cpufreq: avoid an unnecessary double free when finished in pcc_cpufreq_do_osc()
> > 
> > There is no need to fall through the out_free label thus saving a kfree call.
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
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
> 

Silly me, I must be asleep still. Pekka's attached patch is just right.
Sorry for the noise.

Davidlohr


