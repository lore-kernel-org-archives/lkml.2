Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2ATCEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:04:01 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43698 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751344Ab2ATCD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:03:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pGCysBoVM1lRJiaIb5Dal.WtL._cjJGQtWPCB1mnx3WGRQ7
 mYBGQerYKQVwMoHNp0yNuw2itpHyVoj0ooki9AKXCZ0QWqD2oK6gZkC1BKi1
 ZjRaG7MCwmsyO3IY0TI2twNE.WE3CFuXM3mRw0ROyOBUXWELk5zwWQnw34Y.
 Fj9Z7viW77Lx55SSSb1f9UDyj6wpqXBUSWF4ZWYUiz1O9EYAGKHGerxxB0.9
 RLBEFA_4BFOVlnLrKOU44j2iPyCHqf1wSKiqNl39_JQBfHM62OIq2QbrY6Gr
 QricGsDuFbqWIFbwOURCdjHUy_z4Zwt5it3smiwVe5aFx3iIaz_mrhlRBAUH
 L91ERwtojqUXCGfU6GeOtcuYRBSz8UaExd.wL2lCUK1sexEDhCFq_F9oZUxe
 i
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 19 Jan 2012 20:03:51 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        davem <davem@davemloft.net>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Hung task when calling clone() due to netfilter/slab
In-Reply-To: <m14nvr2vbu.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.2.00.1201191959540.14480@router.home>
References: <1326558605.19951.7.camel@lappy> <1326561043.5287.24.camel@edumazet-laptop> <1326632384.11711.3.camel@lappy> <1326648305.5287.78.camel@edumazet-laptop> <alpine.DEB.2.00.1201170910130.4800@router.home> <1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.DEB.2.00.1201170927020.4800@router.home> <1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1201170942240.4800@router.home> <alpine.DEB.2.00.1201171620590.14697@router.home> <m1bopz2ws3.fsf@fess.ebiederm.org>
 <m14nvr2vbu.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, Eric W. Biederman wrote:

> Oh.  I see.  The problem is calling kobject_uevent (which happens to
> live in slabs sysfs_slab_add) with a lock held.  And kobject_uevent
> makes a blocking call to userspace.
>
> No locks held seems to be a good policy on that one.

Well we can just remove that call to kobject_uevent instead then. Does it
do anything useful? Cannot remember why we put that in there.

