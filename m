Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab2HVVtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:49:35 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:51057 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2HVVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:49:33 -0400
Message-ID: <503553EF.1090508@halfdog.net>
Date: Wed, 22 Aug 2012 21:49:35 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14a1
MIME-Version: 1.0
To: kirill.shutemov@linux.intel.com, Alexander Viro <viro@zeniv.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Search for patch for kernel stack data disclosure in binfmt_script
 during execve
References: <502FA000.8090700@halfdog.net> <5030A65D.90305@halfdog.net>
In-Reply-To: <5030A65D.90305@halfdog.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got a hint via IRC, that I should not send patch idea for review to
"generic" list, but to maintainers and last (or relevant) comitters of code.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=bf2a9a39639b8b51377905397a5005f444e9a892

CC to generic just for the records

halfdog wrote:
> halfdog wrote:
>> I'm searching for a patch for linux kernel stack disclosure in 
>> binfmt_script with crafted interpreter names when CONFIG_MODULES
>> is active (see [1]).
> 
> Please disregard my previous proposal [2], since it did not address
> the problem directly (referencing local stack frame data from bprm
> structure) but worked around it. I suspect, that this could increase
> probability to reintroduce similar bugs.
> 
> Opinions on (untested sketch for) second solution: Could someone look
> on the source code comments and changes in patch to judge, if this is
> going in the right direction?
> 
> 
> Explanation of patch: Since load_script will start to irreversibly
> change bprm structures at some point (using stack local data was one
> of those changes), try to delay this point. Run checks if load_script
> could be the right handler, if not give other binfmt handlers the
> chance to do so.
> 
> If binfmt_script is the right one, try to load the interpreter
> (causing bprm modification), if failing make sure that no other binfmt
> handler has the chance to continue on the now modified bprm data.
> 
> CAVEAT: This assumes, that if binfmt_script could handle the load,
> that it would be the one and only binfmt with that ability, so no
> other one, e.g. binfmt_misc should have the chance to do so. If this
> assumption is wrong, leaving binfmt_script would have to rollback all
> bprm changes (e.g. restore old credentials).
> 
> hd
> 
> [1]
> http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/
> [2] http://lkml.org/lkml/2012/8/18/75
> 
> 

-- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
