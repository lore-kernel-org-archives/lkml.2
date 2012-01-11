Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab2AKR77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:59:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55397 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab2AKR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:59:58 -0500
Date: Wed, 11 Jan 2012 21:59:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
Message-ID: <20120111175952.GI466@moon>
References: <20120111161939.GI8752@moon>
 <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:25:04PM -0500, KOSAKI Motohiro wrote:
> > In turn doing everything in a manner of syscall "compare resources of two pids"
> > gives up very slow speed because we will have to compare every pid resources
> > with every other pids we're checkpointing.
> 
> Could you please write down pseudo code of your userland compare logic? When
> and why do you need? I still don't like this idea, but maybe I need to
> understand your
> requerement before putting negative comments.
> 

Hi Kosaki,

the idea on user-space is something like

 - collect all pids to dump
 - collect IDs for every pid
 - sort the IDs obtained
 - find the same IDs (which will be kind of find intersections in a sets of IDs) and
   set up CLONE_ flags on restore procedure as appropriate (for example if
   GEN_OBJ_ID_VM IDs for two or more tasks are the same we need to use CLONE_VM
   at restore time, and so on).

	Cyrill
