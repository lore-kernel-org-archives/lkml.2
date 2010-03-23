Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab0CWLnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:43:47 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56233 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0CWLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:43:46 -0400
Date: Tue, 23 Mar 2010 12:44:09 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cpufreq: Unify sysfs attribute definition macros
Message-ID: <20100323114408.GB16493@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <1269283121-11894-2-git-send-email-bp@amd64.org>
 <201003231207.29230.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003231207.29230.trenn@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>
Date: Tue, Mar 23, 2010 at 12:07:29PM +0100

> > +#define define_one_global_ro(_name)		\
> > +static struct global_attr _name =		\
> > +__ATTR(_name, 0444, show_##_name, NULL)
> > +
> > +#define define_one_global_rw(_name)		\
> > +static struct global_attr _name =		\
> > +__ATTR(_name, 0644, show_##_name, store_##_name)
> 
> These sound like too general names in global space.
> And are unrelated to cpufreq(.h).

maybe call them cpufreq_define_(global|freq)_* then?

> Eventually you get them into sysfs.h with another name
> or just duplicate them?

Well, struct freq_attr for example is cpufreq-specific attribute,
AFAICT. So, keeping them in cpufreq.h should be fine, no?

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
