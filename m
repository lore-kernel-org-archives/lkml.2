Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0CVKiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:38:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab0CVKiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:38:01 -0400
Date: Mon, 22 Mar 2010 11:37:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: oerg Roedel <joro@8bytes.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100322103751.GA3483@elte.hu>
References: <1268717232.2813.36.camel@localhost>
 <1268969929.2813.184.camel@localhost>
 <20100319082122.GE12576@elte.hu>
 <20100319172903.GI13108@8bytes.org>
 <20100321184300.GB25922@elte.hu>
 <20100322101451.GK13108@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322101451.GK13108@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* oerg Roedel <joro@8bytes.org> wrote:

> > It can decide whether it exposes the files. Nor are there any "security 
> > issues" to begin with.
> 
> I am not talking about security. [...]

You were talking about security, in the portion of your mail that you snipped 
out, and which i replied to:

> >      2. The guest can decide for its own if it want to pass this
> >         inforamtion to the host-perf. No security issues at all.

I understood that portion to mean what it says: that your claim that your 
proposal 'has no security issues at all', in contrast to my suggestion.

> [...] Security was sufficiently flamed about already.

All i saw was my suggestion to allow a guest to securely (and scalably and 
conveniently) integrate/mount its filesystems to the host if both sides (both 
the host and the guest) permit it, to make it easier for instrumentation to 
pick up symbol details.

I.e. if a guest runs then its filesystem may be present on the host side as:

   /guests/Fedora-G1/
   /guests/Fedora-G1/proc/
   /guests/Fedora-G1/usr/
   /guests/Fedora-G1/.../

( This feature would be configurable and would be default-off, to maintain the 
  current status quo. )

i.e. it's a bit like sshfs or NFS or loopback block mounts, just in an 
integrated and working fashion (sshfs doesnt work well with /proc for example) 
and more guest transparent (obviously sshfs or NFS exports need per guest 
configuration), and lower overhead than sshfs/NFS - i.e. without the 
(unnecessary) networking overhead.

That suggestion was 'countered' by an unsubstantiated claim by Anthony that 
this kind of usability feature would somehow be a 'security nighmare'.

In reality it is just an incremental, more usable, faster and more 
guest-transparent form of what is already possible today via:

  - loopback mounts on host
  - NFS exports
  - SMB exports
  - sshfs
  - (and other mechanisms)

I wish there was at least flaming about it - as flames tend to have at least 
some specifics in them.

What i saw instead was a claim about a 'security nightmare', which was, when i 
asked for specifics, was followed by deafening silence. And you appear to have 
repeated that claim here, unwilling to back it up with specifics.

Thanks,

	Ingo
