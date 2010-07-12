Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0GLVTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:19:53 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:50726 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0GLVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=date:from
	:to:cc:subject:in-reply-to:message-id:references:mime-version
	:content-type; q=dns; s=drama; b=H9nHqAukY0i+CWMiqSzZ/NeHpPKbXZX
	aS1ZyWIqg4rlvhklNlhqJOY2tuO/I44Q9nYxei7nadHha5TCUS7DJmVwGOWdKYlZ
	3hNhN8NsJWJXos9lPRvO6yCOomSlF8eSodIaGSetDYhAmQnrh/+pbruxtITR9ogU
	EPJwJHNNIPHA=
Date: Mon, 12 Jul 2010 14:21:46 -0700 (PDT)
From: Yehuda Sadeh <yehuda@hq.newdream.net>
X-X-Sender: yehudasa@yehudasa-desktop
To: Jason Baron <jbaron@redhat.com>
cc: Thomas Renninger <trenn@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, yehuda@hq.newdream.net
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
In-Reply-To: <20100712162140.GA2925@redhat.com>
Message-ID: <alpine.DEB.2.00.1007121359010.17416@yehudasa-desktop>
References: <201007011744.19564.trenn@suse.de> <201007091303.08693.trenn@suse.de> <20100709133019.GA2856@redhat.com> <201007121624.17543.trenn@suse.de> <20100712162140.GA2925@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jul 2010, Jason Baron wrote:
...
> I will re-post the above as a separate thread. Also, I should probably
> post a patch to add myself to the MAINTAINERS file, since I didn't see
> Yehuda's patch until now...

Yeah, I wasn't sure who was responsible for this module. Wasn't clear 
from the log.

>
>> If Yehuda's patch is fixing this already, we still need it backported for
>> 2.6.34 stable kernel and further?
>>
>
> Yes, patch might need to be adjusted a bit but is still relevant for
> 2.6.34 stable. The situation was exacerbated by:
>
> commit 3bafeb6247042dcbb72b0141ec7c7107de9f0b99
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Jun 5 11:17:36 2010 -0600
>
>    module: move find_module check to end
>
> during the 2.6.35 time frame.
>

Right. Looking at the code, pre .35-rc2 loads the dynamic debug code after 
verifying that the module is loadable. So it's a bit harder to hit 
it, although it can still fail at the following module_finalize() or at 
the parse_args(), so the problem is there.

Yehuda
