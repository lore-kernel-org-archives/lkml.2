Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1LaHvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 02:51:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38038 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1LaHvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 02:51:08 -0500
Date: Sat, 31 Dec 2011 11:51:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111231075102.GQ4806@moon>
References: <20111228170116.GQ17712@google.com>
 <20111228171419.GA19321@moon>
 <20111229142438.GI4460@moon>
 <20111229161414.GC3516@google.com>
 <20111229162453.GC4806@moon>
 <20111230002309.GA11508@gondor.apana.org.au>
 <20111230073655.GE4806@moon>
 <4EFE1FA4.3090207@gmail.com>
 <20111230204836.GP4806@moon>
 <4EFE4E89.6000607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFE4E89.6000607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 06:51:37PM -0500, KOSAKI Motohiro wrote:
...
> >
> >Guys, this become more and more complex, finally I fear someone
> >propose to do ideal hashing run-time ;) Maybe we can step back and
> >live with root-only and plain pointers here? I'm not sure who else
> >might need such facility except us, and if once there will be a candidate
> >-- we could take a look on hashing again and provide safe hashes there. No?
> 
> But recently kernel security fashion are, we don't expose a kernel
> pointer at all even though the file is root only. I'm not sure how
> much effective such fashion. but you seems run opposite way.
> 
> I doubt user land can implement good comparison way. Why you gave up
> Andrew's sys_are_these_files_the_same() idea?
> 

Because of speed, as Pavel mentioned
 |
 | With this the complexity of determining sharing for N files scattered across
 | several tasks would be N^2, since we'll have to compare each file to each file.
 |
 | On the other hand having just N IDs at hands would allow us to use more
 | efficient algorithms resulting in e.g. N*log(N) complexity.
 |

	Cyrill
