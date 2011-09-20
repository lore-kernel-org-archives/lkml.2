Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1ITIeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:34:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44679 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1ITIeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:34:07 -0400
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
In-Reply-To: <4E77CB30.3030509@google.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316031196.5040.46.camel@twins> <m2fwjyg9fx.fsf@firstfloor.org>
	 <1316076989.3045.8.camel@twins> <4E77CB30.3030509@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 10:33:22 +0200
Message-ID: <1316507602.6091.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 16:07 -0700, Paul Turner wrote:
> At that point we could !CONFIG_CGROUP_CPUACCT by default and deprecate 
> the beast without breaking ABI for those who really need it (either 
> because their applications have hard-coded paths or because they really 
> like cgroup user/sys time -- which we COULD duplicate into cpu but I'm 
> inclined not to).
> 
> [*]: the only real caveat is how loudly people scream about the code 
> duplication; I think it's worth it if it let's us kill cpuacct in the 
> long run. 

Right so this patch is all about extended the stat crap, so that would
have to be duplicated as well.

IIRC the reason cpuacct is a separate controller, is that it then
doesn't add the overhead it incurs to the regular cpu controller.

But I figure we could add some control knobs on the cpu cgroup mount to
enable/disable certain features.

Having two separate cgroup hierarchies for the scheduler is quite daft
of course.
