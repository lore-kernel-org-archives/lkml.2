Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2LQV7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:59:53 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:37612 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2LQV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:59:52 -0500
Message-ID: <50CF95D2.3040900@cesarb.net>
Date: Mon, 17 Dec 2012 19:59:46 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net> <50CEF080.8010208@suse.cz> <20121217102714.GB31947@liondog.tnic> <1355758544.13361.14.camel@joe-AO722> <20121217170011.GC31866@liondog.tnic>
In-Reply-To: <20121217170011.GC31866@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 17-12-2012 15:00, Borislav Petkov escreveu:
> On Mon, Dec 17, 2012 at 07:35:44AM -0800, Joe Perches wrote:
>> Perhaps Cesar can use his script as a starting point to find those
>> pattern invalidating commits or maybe add the capability (or a
>> --strict check) to checkpatch.
>
> Or that, I don't have a strict preference.
>
> So, yeah, I can see how checkpatch saying: "you've just renamed a
> file and thusly invalidated a pattern in MAINTAINERS. Pls, consider
> correcting the pattern" could make sense. And I would even add it to
> default functionality since the MAINTAINERS patterns are something we
> want to always have up-to-date, IMO.

Good idea, but a standalone MAINTAINERS checker is still useful, to 
check for things checkpatch did not catch, either because it was not 
run, or because it did not have enough information.

For instance, consider the case of a patch removing the last file in a 
directory going in via one branch, while a patch adding a file pattern 
for that same directory goes in via a separate branch. There is no way 
checkpatch can catch that.

As for finding the pattern invalidating commits, it is usually not that 
hard, a simple "git log -- <pattern>" or similar usually does the trick, 
except in the cases where the pattern addition itself was wrong. The 
hard part can be interpreting it and the surrounding commits to find out 
the committer's intention, how it should affect the MAINTAINERS entry, 
and who should get a Cc: of the fix.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
