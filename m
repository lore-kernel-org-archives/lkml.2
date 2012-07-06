Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab2GFPKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:10:45 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:40665 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750968Ab2GFPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:10:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b_5I59cVM1kmhZg.vpCsleyn5rYmQ_l_y6Vj3MnDU5r7Efy
 sJB6Bmboc6KjxWNmQ07D2aTjGnqsPvALuxPqYJ6OPlUWiVDE6SAzwbdTQdNu
 5MTSbYMinr1qogdxRZGVO.cMZ7zwMNUvfHZhXO7NH_DaZr.mV1KGnI8wHb2z
 WFQmppQYtfR4EMKAY4vyyPfA6cpykALexyE1Av46QCGYrZZjSawZ65bDjD8c
 rQzPWOVeng4QlGsr6pSgfr6prHp6zIlJpUJdsEc1QaEZxeVkaCIIEkTlWQ_I
 PxRFVKKpPhhHZis.BR.yFO6v.RTf7uUsBH4g0TJmP1LF5tLvuXI.dhUO0IG2
 tpSn_PhfbWYgafwF._eMjiOz94z4Q40e.sAIowzt_hdfozbrZxQ531Zuyw0L
 U
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 6 Jul 2012 10:10:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] slub: release a lock if freeing object with a lock
 is failed in __slab_free()
In-Reply-To: <CAAmzW4P941qeKy6UH079r73zR5VjUeNZNB53Mi4wiHE28f==gg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207061008560.28648@router.home>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com> <1340389359-2407-3-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207050924330.4138@router.home> <CAAmzW4NJyX9e_dMyJBA5zDiVYVmL1vbUkaRHNoSbbhDZWW7iMg@mail.gmail.com>
 <alpine.DEB.2.00.1207060928580.26790@router.home> <CAAmzW4P941qeKy6UH079r73zR5VjUeNZNB53Mi4wiHE28f==gg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, JoonSoo Kim wrote:

> >> At CPU2, we don't need lock anymore, because this slab already in partial list.
> >
> > For that scenario we could also simply do a trylock there and redo
> > the loop if we fail. But still what guarantees that another process will
> > not modify the page struct between fetching the data and a successful
> > trylock?
>
>
> I'm not familiar with English, so take my ability to understand into
> consideration.

I have a hard time understanding what you want to accomplish here.

> we don't need guarantees that another process will not modify
> the page struct between fetching the data and a successful trylock.

No we do not need that since the cmpxchg will then fail.

Maybe it would be useful to split this patch into two?

One where you introduce the dropping of the lock and the other where you
get rid of certain code paths?

