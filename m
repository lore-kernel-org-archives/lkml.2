Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0EPLNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 07:13:55 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35408 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0EPLNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 07:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QyTwtbyysuXJ4JD+4NlsyDv9zsPIfmwYDVIbJAp1cJRvfT+RhwhWEt68jGVcZ8hou8
         c50FTxq0VfjvlTbGT6zSDlLUtXimHb/zx6dRPpmBLC0H9MkssBnQVThTwzpubJ4Y/iWa
         RHMqCYSC8EWy2izZKnwwGvyK48dLj20rocq3M=
MIME-Version: 1.0
In-Reply-To: <20100510140527.GG5199@sirena.org.uk>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
Date: Sun, 16 May 2010 16:43:52 +0530
Message-ID: <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
Subject: Re: [linux-pm] Power Domain Framework
From: Sundar <sunder.svit@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>, viresh.kumar@st.com,
       rajeev-dlh.kumar@st.com, armando.visconti@st.com,
       linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
       linux-pm@lists.linux-foundation.org, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The regulator framework documentation already refers to the concept of
power domains and I think the framework *can* be extended more to
support on-SoC power domains as well.

I have been working with the regulator framework for on-chip power
domains too and....

>2. Maintain a list of the different power domains present.
>3. The devices in a specific power domain, as per the requirements would get the power
>domain...
>4. Typically a usage count of zero for any power domai..
>5. The same could be mapped on to the PM framework..
>6. The model could further be build upon to check any dependency in the power domains

the above requirements can be leveraged through the current regulator
framework itself.

However, for working with power domains within the framework, I feel that,
- support must be added to allow additional domain-specific states
like retention, idle etc.
- controlling operating points for regulators, unlike setting optimal modes.
- controlling regulator modes via constraints enforced by clients and
managing transition to various states through the client requests and
pushing the client states up to the parent regulator.

>7. The advantages of the framework could be leveraged in the CPU idle time, by switching >off the Power domains with zero usage counts.

Yes. A simple platform specific list of all regulators ( and power
domains ) can be easily used in the CPUIdle driver for determining low
power states. Further, enforcing run time PM can club together any
peripheral's power sources in terms of external regulators, on-chip
domains ( and clock sources possibly).

i have a very primitive implementation for adding operating points and
constraints into the framework and currently i am able to control
regulator aka domain states based on various child domains and
contraints.

However, with more inputs, I think we can make the regulator framework
easily manage power sources, whether on-chip domains or external
conventional regulators...

Waiting for opinions and views,

Regards,
Sundar

 Mon, May 10, 2010 at 7:35 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, May 10, 2010 at 07:16:06PM +0530, Deepak Sikri wrote:
>
>> In our System on chip we have several power domains. As such there is no
>> generic framework for the Power Domains in linux , and I find huge potential
>> in the software to control the domains and exploit the power management
>> capabilities.
>
>> There is one very small model that I could think of, something on the lines
>> of clock framework.
>
> Might be worth looking at what the OMAP and SH Mobile CPUs are doing
> here, they have existing handling for power domains.  Off-SoC the
> regulator API should already cope with a lot of this stuff.
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
>
