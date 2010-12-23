Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0LWSN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 13:13:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9254 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0LWSN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 13:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Uhu8PnAip8PEo1xLk1JIPhpELx9fz8k6k2r5TDYSVaV1BmNG/7pz0YHwy45e2SFx+D
         CgV1hu53t1asB6WpGVLw==
MIME-Version: 1.0
In-Reply-To: <20101223143859.GA1402@srcf.ucam.org>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
	<1293085424-18212-2-git-send-email-youquan.song@intel.com>
	<1293085424-18212-3-git-send-email-youquan.song@intel.com>
	<1293085424-18212-4-git-send-email-youquan.song@intel.com>
	<1293085424-18212-5-git-send-email-youquan.song@intel.com>
	<1293085424-18212-6-git-send-email-youquan.song@intel.com>
	<1293085424-18212-7-git-send-email-youquan.song@intel.com>
	<20101223105730.GB18363@comet.dominikbrodowski.net>
	<20101223143859.GA1402@srcf.ucam.org>
Date: Thu, 23 Dec 2010 10:13:54 -0800
Message-ID: <AANLkTi=XkMqUSfO076mVqGCHv-Kw-jnuL8dZiN17ypqZ@mail.gmail.com>
Subject: Re: [PATCH 6/6] cpufreq: Evaluate P1 before enter turbo mode
From: Venkatesh Pallipadi <venki@google.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Youquan Song <youquan.song@intel.com>, davej@redhat.com,
        cpufreq@vger.kernel.org, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 6:38 AM, Matthew Garrett <mjg@redhat.com> wrote:
> On Thu, Dec 23, 2010 at 11:57:30AM +0100, Dominik Brodowski wrote:
>
>> NACK. First of all, why is it only a "turbo mode" if it's 1000 kHz
>> difference?
>
> I believe that that's how it's supposed to be defined for Intel systems,
> but you're right that this doesn't belong in generic code. AMD have
> support for enabling/disabling their equivalent functionality through
> sysfs - I'd say that copying that interface and using it to limit the
> set of p-states provided to the core makes more sense.
>

If this 1000kHz hack is needed, it should be in acpi-cpufreq driver
along with Intel CPU and Turbo mode capability check..
I had a change earlier and I don't think I ever pushed it out. But, it
was doing the max freq transition on turbo capable CPUs in 2 steps.
Something like:
- cpu is in one of the low freqs.
- ondemand asks for highest freq.
- acpi-cpufreq will check whether the CPU is turbo capable and will
only switch to non-turbo peak freq as first step.
- If ondemand asks for highest freq again, acpi-cpufreq will then
switch to turbo freq.

Something like that would probably help the problem here?

Thanks,
Venki


Thanks,
Venki
