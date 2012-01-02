Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2ABVGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:06:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54583 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2ABVGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:06:16 -0500
From: bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Date: Mon, 2 Jan 2012 13:18:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20111228170116.GQ17712@google.com> <4EFE4E89.6000607@gmail.com> <20111231075102.GQ4806@moon>
In-Reply-To: <20111231075102.GQ4806@moon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201021318.15130.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 31 December 2011 08:51:02, Cyrill Gorcunov a écrit :
> On Fri, Dec 30, 2011 at 06:51:37PM -0500, KOSAKI Motohiro wrote:
> ...
> 
> > >Guys, this become more and more complex, finally I fear someone
> > >propose to do ideal hashing run-time ;) Maybe we can step back and
> > >live with root-only and plain pointers here? I'm not sure who else
> > >might need such facility except us, and if once there will be a
> > >candidate -- we could take a look on hashing again and provide safe
> > >hashes there. No?
> > 
> > But recently kernel security fashion are, we don't expose a kernel
> > pointer at all even though the file is root only. I'm not sure how
> > much effective such fashion. but you seems run opposite way.
> > 
> > I doubt user land can implement good comparison way. Why you gave up
> > Andrew's sys_are_these_files_the_same() idea?

By memory, it seems that fuse expose kernel pointer encrypting it with tea. Tea is simple and quick you should get a glimpse at 
it.

> Because of speed, as Pavel mentioned
> 
>  | With this the complexity of determining sharing for N files scattered
>  | across several tasks would be N^2, since we'll have to compare each
>  | file to each file.
>  | 
>  | On the other hand having just N IDs at hands would allow us to use more
>  | efficient algorithms resulting in e.g. N*log(N) complexity.



> 	Cyrill
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
