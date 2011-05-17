Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1EQNzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:55:37 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:39190 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754697Ab1EQNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:55:36 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: R1m6J4oVM1n8ibXH1DcgM6Z6dvgN78rkgVrdktSzgPYz7Io
 rI2mcqz9jduN5.aCla_gYT8QvL23hsOviU8F7yHcEvaTDT3LuBqyqBF8BunG
 tGEQC43m3JY6Sk9JV__sqvchWvh53_mIgyTMz4EJTFuzPfYo5oY3G_UxxWcI
 eHgjQjgeKog53DLPfHXgLLPHuiq0DgChZWwWs2wm.YY_bI2X4d1NQbnqXRYE
 MRL2py_szyRgsFAVqjU3kvujK6lKnDTcSGAv169iZKum.EOP2sj1UxkPKXzd
 G928f4axJDav030h9tUoIri8OopIS8YMLm9kMgBMh8yrs0DbW
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 May 2011 08:55:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch V3] percpu_counter: scalability works
In-Reply-To: <20110517130414.GO20624@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1105170853520.11187@router.home>
References: <1305593751.2375.69.camel@sli10-conroe> <1305608212.9466.45.camel@edumazet-laptop> <1305609768.2375.84.camel@sli10-conroe> <1305622861.2850.21.camel@edumazet-laptop> <20110517091102.GE20624@htj.dyndns.org> <1305625541.2850.29.camel@edumazet-laptop>
 <20110517095001.GF20624@htj.dyndns.org> <1305634807.2850.89.camel@edumazet-laptop> <20110517124528.GN20624@htj.dyndns.org> <1305637223.2850.95.camel@edumazet-laptop> <20110517130414.GO20624@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Tejun Heo wrote:

> Hello,
>
> On Tue, May 17, 2011 at 03:00:23PM +0200, Eric Dumazet wrote:
> > Absolutely not. Its slow path yes, but not super-slow.
>
> I was speaking in relative terms.  We're talking about local only fast
> path vs. something which hits every percpu counter likely causing
> cache misses in many of them.  It's bound to be multiple orders of
> magnitude heavier than fast path.

Well lets just adopt the system that vm statistics use. Bound the error by
time and batch and allow the user to change the batch if more accuracy is
desired.

The _sum function is optional and should it should be explained that the
result *could* be better but dont count on it.

