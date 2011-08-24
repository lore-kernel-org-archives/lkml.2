Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1HXRhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:37:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:63146 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1HXRhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,276,1312182000"; 
   d="scan'208";a="44660019"
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Zan Lynx <zlynx@acm.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        "containers\@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
References: <20110824085329.GL29452@sun> <4E551331.1010709@acm.org>
	<4E551693.5030400@parallels.com>
Date: Wed, 24 Aug 2011 10:36:58 -0700
In-Reply-To: <4E551693.5030400@parallels.com> (Pavel Emelyanov's message of
	"Wed, 24 Aug 2011 19:19:47 +0400")
Message-ID: <m2wre2d83p.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@parallels.com> writes:
>
> No and this is the trick - when you readlink it - it give you trash, but
> when you open one - you get exactly the same file as the map points to.

Isn't that a minor security hole?

For example if I pass a file descriptor into a chroot process for
reading, and with this interface you can open it for writing too.
I could see this causing problems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
