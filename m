Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab1DVPRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:17:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:1264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab1DVPR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:17:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,254,1301900400"; 
   d="scan'208";a="737069072"
Date: Fri, 22 Apr 2011 08:16:19 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] SELINUX: Make selinux cache VFS RCU walks safe
Message-ID: <20110422151619.GA10755@tassilo.jf.intel.com>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
 <1303431801-10540-3-git-send-email-andi@firstfloor.org>
 <BANLkTik2Pc=A1b41oNanZ--bsX0OHhbA+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik2Pc=A1b41oNanZ--bsX0OHhbA+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 08:45:17PM -0400, Eric Paris wrote:
> I'll take a close look over the weekend, but I'm pretty sure this is
> even more strict than it needs to be.  I looked at this a while ago
> and the only RCU unsafe location I could find was in the generic LSM
> 'audit' code (nothing to do with the audit subsystem).  That code can
> do a d = d_find_alias(); dput(d).  I don't think I realized the dput()
> was not RCU safe at the time.  We use it to come up with a name of a
> dentry that might have caused the denial (although obviously not
> necessarily the right name)
> 
> I could just drop that piece of functionality (and rely on the audit
> subsystem for the info), but I think I'd rather do it your way.  I
> think I can push your flags a lot deeper than you have pushed them
> (and remove them in some places you have included them).  Let me look
> over the next day or two....

Sounds good. I would prefer to do that as a follow on patch to make
this patch not even more complicated. Is that ok for you?

Also the same approach could be applied to SMACK then I guess.

-Andi
