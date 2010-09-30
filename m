Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0I3UGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab0I3UGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:06:44 -0400
Date: Thu, 30 Sep 2010 16:06:17 -0400
From: Dave Jones <davej@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: dave@gnu.org, cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86 maintainers <x86@kernel.org>
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
Message-ID: <20100930200617.GA4120@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pekka Enberg <penberg@kernel.org>, dave@gnu.org,
	cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	x86 maintainers <x86@kernel.org>
References: <1285875804.2180.1.camel@cowboy>
 <AANLkTikbSYutRGwQLU2srEQG6CO7pvXdFBQ0W216DoCv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikbSYutRGwQLU2srEQG6CO7pvXdFBQ0W216DoCv@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 10:59:51PM +0300, Pekka Enberg wrote:
 > > +++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
 > > @@ -379,6 +379,8 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *handle)
 > >        if (!(supported & 0x1))
 > >                return -ENODEV;
 > >
 > > +       return ret;
 > > +
 > >  out_free:
 > >        kfree(output.pointer);
 > >        return ret;
 > 
 > Where is the double free here? I can't see it. I do see memory leaks
 > happening in error handling paths of pcc_cpufreq_do_osc() which makes
 > me think we need something like the attached patch.

I think Dave's patch is correct.  There's a kfree(output.pointer) at line 359.
If we fall all the way through without hitting any of the return -ENODEVs,
we end up doing a 2nd kfree in the out_free:

	Dave

