Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1LVPBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:01:36 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:30165 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753425Ab1LVO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:58:47 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NNlWPUEVM1nfCqtN1A5uWcMGPcsHn3DVuKXKV9zIDXc7OXd
 zlwycafXPY6APC4A52T9ZlHzNj3G6U151Y8voFL0ESrEDjfMGfsMWc1eBhxz
 n1UCN0pxT0W1hIKnI_KH9zxtfT38QNCuPgCmPZ_rgrUqGQAVmy.fnjpBlshA
 UvsnZqxhey6AtlQ.Dd4bdGzvRYMJlZBjAvwn8yMqEizfh.RKnUXegdY8Ao_v
 .sJ9Ur_IUTBkOFqthGffOXpTICWldqHhYc395KtVhK2d8VuWnBlqSec8Ng0K
 d8HiBY2r4OoB0XpCpLaxn1Jhn3RjcCGnsnWdPESqP9ZCzD64zG6nHnHosMUE
 QqgFqF0_7ptPg4QQcmVbCtrNl1PS_cOlApi3iapeLuqcwnw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Dec 2011 08:58:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <20111221170535.GB9213@google.com>
Message-ID: <alpine.DEB.2.00.1112220854440.31315@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com> <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home> <20111221170535.GB9213@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Tejun Heo wrote:

> The thing is that irqsafe ones are the "complete" ones.  We can use
> irqsafe ones instead of preempt safe ones but not the other way.  This
> matters only if flipping irq is noticeably more expensive than
> inc/dec'ing preempt count but I suspect there are enough such
> machines.  (cc'ing arch) Does anyone have better insight here?  How
> much more expensive are local irq save/restore compared to inc/dec'ing
> preempt count on various archs?

Well that would be a pretty nice simplification of the API.
Replace the fallback code for the preempt safe ones with the
irqsafe fallbacks, then drop the irqsafe variants from percpu.h.

> > The way that the cmpxchg things are used is also similar to transactional
> > memory that is becoming available in the next generation of processors by
> > Intel and that is already available in the current generation of powerpc
> > processors by IBM. It is a way to avoid locking overhead.
>
> Hmmm... how about removing the ones which aren't currently in use?

Yep. Could easily be done. We can resurrect the stuff as needed when other
variants become necessary. In particular the _and and _or etc stuff was
just added to be backward compatible with the old per cpu and local_t
interfaces. There may be no use cases left.


