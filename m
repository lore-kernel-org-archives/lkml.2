Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2EWNsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:48:53 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:45810 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750915Ab2EWNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:48:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2zt1Oh4VM1mD5KGTB8pa0pVsI_6RXF8PeOrC1_lEEQTNMpq
 Umgfuzn_4v6wVAMTpNM56B0tN17zYXYZun0VdAdEo0Kn_4U7POLtM5.WBPhd
 j580a_M8x1Sb7_Av0MQsDGpqA_kxDBNEHFktw5zRjwir8btrS8_7HqwNeNb5
 bAx3Ie1YPuIRQkyZLm5wuikImclBc6CTbaqkJtdwls0BwfxkFt9J1RgPZN6D
 ct8.HmMuF_zkH7st.gaR8q.HkeUinGcP8hqImEm7i0j50JdoApMeFa80Ua6V
 _M_QMCAyx4zPVkMXkhVcLY1GZvpmkl8Vdi8b9jQOXZXXBu.9LuLeB_j7dBzM
 RYNU3es7a4tvcAaKyVg3uZKX_LD3TMo9U1K6Pe3a5hlNW_Vr6oKu91InUHGu
 0k7.uFjHGuNQZFw4xy8tpgie5J1g9v6C9bipg
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 23 May 2012 08:48:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
In-Reply-To: <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1205230847580.29893@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home>
 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, David Rientjes wrote:

> On Tue, 22 May 2012, Christoph Lameter wrote:
>
> > > I think that's precisely David's point: that we might want to destroy them
> > > eventually.
> >
> > Cannot imagine why.
> >
>
> We can't predict how slab will be extended in the future and this affects
> anything created before g_cpucache_cpu <= EARLY.  This would introduce the
> first problem with destroying such caches and is unnecessary if a
> workaround exists.

Changes to the very early bootstrap code of slab allocators are rare and
the code there is dicey anyways. It is much more risky to add additional
allocations of varying length at that stage.

