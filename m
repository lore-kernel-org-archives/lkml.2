Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab1ERNDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:03:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45650 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab1ERNDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tl0zWr7OvZfSYRQUGtW4I5VxcXSDPoovxhOrZarqJy9nWE/61/Ouzp47hNJILVjQQI
         ojgLPSy57Xsf6J9ftbAVDqYBEtxM5m/g/BKAa++kCLB23/ecY6zCwISIxRqWjeL80MrH
         slE5RD2r/35oQLgWDsxo0uU6lp81k/+K/CGWU=
MIME-Version: 1.0
In-Reply-To: <20110518124307.GD3762520@jupiter.n2.diac24.net>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<20110518124307.GD3762520@jupiter.n2.diac24.net>
Date: Wed, 18 May 2011 16:03:03 +0300
Message-ID: <BANLkTikmrC86hk=W84UBwhJLe_uGAN4w9w@mail.gmail.com>
Subject: Re: Identifying network namespaces (was: Network namespace
 manipulation with file descriptors)
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Lamparter <equinox@diac24.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 3:43 PM, David Lamparter <equinox@diac24.net> wrote:
> -   processes cannot easily be cross referenced with each other
>
>  in the case of user space stuff running astray - like management
>  software crashing, routing daemons screwing up, etc. - it becomes
>  fairly difficult to shut down a network namespace (or even reaquire
>  physical devices that have been reassigned)

It shutdowns itself when last process using netns disappeares,
so if you kill your routing daemons you should be fine.
Physical netdevices are moved to init_net.

> -   namespaces cannot adequately be identified to the user
>
>  for debugging, some kernel messages become useless. most prominently,
>  "unregister_netdevice: waiting for lo to become free. Usage count = 123"
>  could certainly use some clarification, *which* lo is meant...

There is no "netns %p" or something, because right now the only unique
netns identifier is kernel pointer (which better not be exposed to userspace).
Printing such thing would be quite useless since it's not printed
at netns creation.

> So, considering this set of premises (feedback welcome) I looked for
> some suitable means of identification. I discarded going for any process
> identifiers since Eric's patches allow for network namespaces without
> any process holding a reference, using bind mounts instead.

If anything it should be netns->id, /proc/*/netns outputting id
where id is not derived from kernel pointer.

> Solution?
> =========

What a hack! :-)
