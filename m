Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1I2OoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:44:14 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:64611 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1I2OoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:44:12 -0400
Subject: Re: [PATCH] Smack: fix domain transfer issues
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1109291634380.3006@jsakkine-mobl>
References: <1317206909-24443-1-git-send-email-jarkko.sakkinen@intel.com>
	 <1317222904.20139.20.camel@moss-pluto>
	 <alpine.DEB.2.02.1109291109070.3006@jsakkine-mobl>
	 <1317302436.4079.22.camel@moss-pluto>
	 <alpine.DEB.2.02.1109291634380.3006@jsakkine-mobl>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Thu, 29 Sep 2011 10:44:06 -0400
Message-ID: <1317307446.4079.33.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 16:57 +0300, Jarkko Sakkinen wrote:
> On Thu, 29 Sep 2011, Stephen Smalley wrote:
> 
> > On Thu, 2011-09-29 at 11:26 +0300, Jarkko Sakkinen wrote:
> >> MNT_NOSUID should be checked.
> >
> > Doubtful, as Smack and capabilities are completely orthogonal, right?
> > Even for SELinux, the nosuid check is a bit of a nuisance.
> 
> What I'm planning to do is to not switch
> domain if filesystem is mounted with nosuid.
> Same logic as prepare_binprm does for suid
> and sgid bits.

I'm not sure that is required since a Smack label change doesn't alter
the allowable capabilities, and doing so will create conflicts for users
who will have to choose between supporting Smack label transitions on a
filesystem and mounting it nosuid.  We've seen such issues for SELinux.
Having a separate flag for label transitions would be better.

Also, if it is possible for an exec label to be ignored/overridden, then
you might want to consider an equivalent to the SELinux execute_no_trans
check.

> I've already added death signal clearing to the
> next-to-be-submitted revision of this patch.
> I'm planning to implemented flushing of
> non-permissible files and signals as two separate
> patches later on (in the near future however).

I'd view the lack of equivalents to the transition and entrypoint checks
as more critical, as well as the lack of any control over the
relationship between the file access control label and its exec label.
How can you determine what labels are reachable from a given label?  How
can you determine what programs can be used to enter a given label?  How
can you determine who can modify a program that can be used to enter a
given label?

-- 
Stephen Smalley
National Security Agency

