Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2E3Ph5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:37:57 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:28201 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753552Ab2E3Phz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:37:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: kyfKDwYVM1nmbaux.u6rbPZEljIpZlhkT5A.DxoatUgXhyE
 qJDfcBCBu.0.o7ABzgu5Ay34ZaEmfvRkC4XVJWt1JMsUcqXkUSVTh.pdCAYY
 mNrsyV5HOG.HEuetQ1Yb.Nd9BxQCmtrX2bRKycy2sljtDheZwQA2BNOkDN.a
 JBMwrAr5PPG6RfB3.AvpjoUrpaW7pWrSjclP5eKawXjaluZdsX4Gr._Bezq2
 q2mIqxefNLZ.yD8KNDI2YDaji1XW.bxgyQzCH2s9gGBpwnxWFYe266SjJA_J
 jSVBuq6tol5hQ2BUjPa_TB3Jwi.QUtwqbbuX1QPW88QSuCExPgc6YgWecQuG
 HKm4itr2mkLwimwTcvEJer76MyW.Jq9hC7.7OXLuZzwaira5UwIufiv4NNbw
 ffb8NWk9B9f9GV66yGzlGB0RR.P6nHdCZCp._
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 10:37:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
In-Reply-To: <CAOS58YPqOBgmXQia5wM1FKKj5zD2K6gbC3EyQyppFnVSM2i-gQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205301036220.28968@router.home>
References: <alpine.DEB.2.00.1205291101580.6723@router.home> <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home> <4FC52612.5060006@parallels.com>
 <alpine.DEB.2.00.1205291454030.2504@router.home> <4FC52CC6.7020109@parallels.com> <alpine.DEB.2.00.1205291514090.2504@router.home> <4FC530C0.30509@parallels.com> <20120530012955.GA4854@google.com> <4FC5D228.2070100@parallels.com>
 <CAOS58YPqOBgmXQia5wM1FKKj5zD2K6gbC3EyQyppFnVSM2i-gQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Tejun Heo wrote:

> Yeah, I prefer your per-cg cache approach but do hope that it stays as
> far from actual allocator code as possible. Christoph, would it be
> acceptable if the cg logic is better separated?

Certainly anything that would allow this to be separated out would be
appreciated. I do not anticipate to ever run cgroup in my environment and
that is due to the additional latency created in key OS paths. Memory we
have enough. The increased cache footprint is killing performance.

