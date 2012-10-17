Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2JQGEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:04:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45238 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752515Ab2JQGEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:04:37 -0400
Message-ID: <1350453876.3072.23.camel@joe-AO722>
Subject: Re: [PATCH 1/2] cpufreq: Improve debug prints
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com
Date: Tue, 16 Oct 2012 23:04:36 -0700
In-Reply-To: <CAKohpo=LL+wPcb97KNQvHbX0fzhnRBZjPsHXTj1PdYObuVVTgw@mail.gmail.com>
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
	 <1350452374.3072.19.camel@joe-AO722>
	 <CAKohpo=LL+wPcb97KNQvHbX0fzhnRBZjPsHXTj1PdYObuVVTgw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 11:25 +0530, Viresh Kumar wrote:
> On 17 October 2012 11:09, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2012-10-17 at 10:50 +0530, Viresh Kumar wrote:
> >> With debug options on, it is difficult to locate cpufreq core's debug prints.
> > []
> >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > []
> >> @@ -15,6 +15,8 @@
> >> +#define pr_fmt(fmt) "cpufreq: " fmt
[]
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> Sorry, i am not sure how KBUILD_MODNAME is compiled by kernel.

KBUILD_MODNAME is a #define that is set by scripts/Makefile.lib.

> So, if i try KBUILD_MODNAME with my patch i get prints as:
> 
> KBUILD_MODNAME: <print - text>

I believe you are quoting KBUILD_MODNAME

try

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

This should create prefixes like
	"cpufreq: "
and
	"cpufreq_performance: "

