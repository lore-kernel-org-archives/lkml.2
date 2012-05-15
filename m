Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab2EOM7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:59:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:49751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2EOM7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:59:10 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
In-Reply-To: <C7197FD5-B8F2-4A92-92AD-5453659592B2@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com>
	 <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com>
	 <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com>
	 <1337077714.27694.21.camel@twins>
	 <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com>
	 <1337083082.27020.151.camel@laptop>
	 <C7197FD5-B8F2-4A92-92AD-5453659592B2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 14:59:05 +0200
Message-ID: <1337086745.27020.161.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 15:32 +0300, Pantelis Antoniou wrote:
> 
> Well, I don't plan to feed the load-balancer all this crap. What I'm thinking
> is take those N metrics, form a vector according to some (yet unknown) weighting 
> factors, and schedule according to the vector value, and how it 'fits' to a
> virtual bin representing a core and it's environment. 

Currently we only have a bit-vector and a retry loop. I suspect you can
make the multi-value vector map to a bit-vector if you can keep cpu wide
statistics to compare against as well.

We want to avoid having to do a full sort.

