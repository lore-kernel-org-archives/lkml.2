Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0CWLze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:55:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab0CWLzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:55:32 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 1/5] cpufreq: Unify sysfs attribute definition macros
Date: Tue, 23 Mar 2010 12:55:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <201003231207.29230.trenn@suse.de> <20100323114408.GB16493@aftab>
In-Reply-To: <20100323114408.GB16493@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231255.30461.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010 12:44:09 Borislav Petkov wrote:
> From: Thomas Renninger <trenn@suse.de>
> Date: Tue, Mar 23, 2010 at 12:07:29PM +0100
> 
> > > +#define define_one_global_ro(_name)		\
> > > +static struct global_attr _name =		\
> > > +__ATTR(_name, 0444, show_##_name, NULL)
> > > +
> > > +#define define_one_global_rw(_name)		\
> > > +static struct global_attr _name =		\
> > > +__ATTR(_name, 0644, show_##_name, store_##_name)
> > 
> > These sound like too general names in global space.
> > And are unrelated to cpufreq(.h).
> 
> maybe call them cpufreq_define_(global|freq)_* then?
> 
> > Eventually you get them into sysfs.h with another name
> > or just duplicate them?
> 
> Well, struct freq_attr for example is cpufreq-specific attribute,
> AFAICT. So, keeping them in cpufreq.h should be fine, no?
You don't need much of these (one or two?).
I'd leave this cleanup out for your patch series.
You care about the boost and aperf/mperf stuff and not about this
cleanup?

    Thomas
