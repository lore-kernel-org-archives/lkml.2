Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab1I2N5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:57:19 -0400
Received: from mga10.intel.com ([192.55.52.92]:23433 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754563Ab1I2N5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:57:18 -0400
Date: Thu, 29 Sep 2011 16:57:04 +0300 (EEST)
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
X-X-Sender: jsakkine@jsakkine-mobl
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: fix domain transfer issues
In-Reply-To: <1317302436.4079.22.camel@moss-pluto>
Message-ID: <alpine.DEB.2.02.1109291634380.3006@jsakkine-mobl>
References: <1317206909-24443-1-git-send-email-jarkko.sakkinen@intel.com> <1317222904.20139.20.camel@moss-pluto> <alpine.DEB.2.02.1109291109070.3006@jsakkine-mobl> <1317302436.4079.22.camel@moss-pluto>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Stephen Smalley wrote:

> On Thu, 2011-09-29 at 11:26 +0300, Jarkko Sakkinen wrote:
>> MNT_NOSUID should be checked.
>
> Doubtful, as Smack and capabilities are completely orthogonal, right?
> Even for SELinux, the nosuid check is a bit of a nuisance.

What I'm planning to do is to not switch
domain if filesystem is mounted with nosuid.
Same logic as prepare_binprm does for suid
and sgid bits.

>>  Also, I'll plan to
>> implement permission check for ptrace but in the
>> scope of this patch.
>
> Still no transition or entrypoint checks, open file revalidation, parent
> death signal clearing, ...?

I've already added death signal clearing to the
next-to-be-submitted revision of this patch.
I'm planning to implemented flushing of
non-permissible files and signals as two separate
patches later on (in the near future however).

/Jarkko
