Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2CMUtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:49:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41082 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050Ab2CMUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:49:18 -0400
X-Sasl-enc: y22w44AoeK75GBPKuI8wCl89myWAfhoThvnNF76wTgsM 1331671757
Date: Tue, 13 Mar 2012 17:49:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH V3] cpuidle: Add a sysfs entry to disable specific C
 state for debug purpose.
Message-ID: <20120313204915.GD3260@khazad-dum.debian.net>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
 <1330647453.1916.7.camel@ymzhang>
 <20120302142303.648285a7.akpm@linux-foundation.org>
 <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
 <4F545A4E.8010801@linux.vnet.ibm.com>
 <4F5466C4.2090808@intel.com>
 <20120305101827.GA19408@khazad-dum.debian.net>
 <1330995854.1916.39.camel@ymzhang>
 <20120313004229.GA21111@khazad-dum.debian.net>
 <1331601480.1916.149.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331601480.1916.149.camel@ymzhang>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Yanmin Zhang wrote:
> > > > > +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> > > > > +		const char *buf, size_t size) \
> > > > > +{ \
> > > > > +	int value; \
> > > > > +	sscanf(buf, "%d", &value); \
> > > > > +	if (value) \
> > > > > +		state->disable = 1; \
> > > > > +	else \
> > > > > +		state->disable = 0; \
> > > > > +	return size; \
> > > > > +}
> > > > 
> > > > Isn't this missing a check for capabilities?  Disabling cpuidle states is
> > > > not something random Joe (and IMHO that does mean random capability-
> > > > restricted Joe root) should be doing...
> > > Sorry. Could you elaborate it?
> > 
> > Sure.  Should any user be able to disable a C state, therefore causing
> > the system to consume more power?
> Here we use the simple way to check access. Only root could change it.

Yea, but capabilities are supposed to constrain root as well :-)

> > I am pretty sure the answer is NO, in which case you should check for
> > the appropriate user credentials before you allow a write to these
> > "debug" controls to succeed.  "capability" here is one of the CAP_*
> > capabilities tested through capable(), which are supposed to limit even
> > root.
> We would add below check.
>  
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;

Looks good.

Thanks!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
