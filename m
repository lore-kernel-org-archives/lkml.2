Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0DUWbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:31:15 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53207 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0DUWbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:31:13 -0400
Date: Wed, 21 Apr 2010 17:30:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
Message-ID: <20100421223059.GA20626@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu>
 <20100419172639.GA15800@us.ibm.com>
 <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
 <20100419213952.GA28494@hallyn.com>
 <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
 <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com>
 <20100420143545.GA19513@us.ibm.com>
 <q2pcb0375e11004211415ge9371513n6fad211823aba2b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q2pcb0375e11004211415ge9371513n6fad211823aba2b3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Lutomirski (luto@mit.edu):
> So if we give up on changing nosuid, there are a couple of things we
> might want to do:
> 
> 1. A mode where execve acts like all filesystems are MNT_NOSUID.  This
> sounds like a bad idea (if nothing else, it will cause apps that use
> selinux's exec_sid mechanism (runcon?) to silently malfunction).

I think at this point we've lost track of exactly what we're trying
to do.

The goal, at least for myself and (I think) Eric, was to prevent
certain changes in environment, initiated by an unprivileged user,
from confusing setuid-root programs (initiated by the user).

A concrete example was the proposed disablenet feature, with which
an unprivileged task can remove its ability to open any new network
connections.

With that in mind, I think option 1 is actually the best option.
I especially hate option 2 because of the resulting temptation to
fudge with pE  :)  If you're going to fudge with pE, then IMO it
MUST be done in a new securebits mode.

Now actually, re-reading my msg, given our original goal, I dare
say that Andrew Morgan's approach of simply returning -EPERM for
any app which tries to setuid or change privileges on exec just
might be the sanest way, at least to start with.

-serge
