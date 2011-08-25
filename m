Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1HYPL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:11:56 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:35645 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754098Ab1HYPLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:11:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QFpAs_8VM1lVtD8Fg7MHAAa07DBGKoGYkCenpWbTC7xbXDY
 Oyo.FDI9enAspC8MdicklQqHZsDWzHFc95GJA5ua_WjXxP9NLl4Arbs41Mr8
 ZealmLb.hFzs4ChxIuKTpz51uo8j2erkJrwPNpJ3Izhm7p_9xGsEvr.IzkVu
 NDEGAqkAO9JZfo9_hGyCs6Hs5TB_7bz0eY3F3ezyTXZSufRvZT0zWWDq2rwp
 h1wsLIMewRT3W2AB9_LuyNkvM4D2R1aMkvJWkRkGWqB2epAxDwIfe5DZPtsU
 CwmolYjyq3zp4pSdJT0Kg3mgnIvUtR9_t8Llstqp.ctShjdY1PdwnD2LywaB
 htnvoKCP8jd3GTHLt64zb.8POasmmIVrnuRzvyNMYldYrYudCSCs3uzj7F5e
 febTFjAgyy7nVBaFWAnrd_A--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 25 Aug 2011 10:11:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
In-Reply-To: <1314284272.27911.32.camel@twins>
Message-ID: <alpine.DEB.2.00.1108251009120.27407@router.home>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>  <20110818144025.8e122a67.akpm@linux-foundation.org> <1314284272.27911.32.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Peter Zijlstra wrote:

> On Thu, 2011-08-18 at 14:40 -0700, Andrew Morton wrote:
> >
> > I think I'll apply it, as the call frequency is low (correct?) and the
> > problem will correct itself as other architectures implement their
> > atomic this_cpu_foo() operations.
>
> Which leads me to wonder, can anything but x86 implement that this_cpu_*
> muck? I doubt any of the risk chips can actually do all this.
> Maybe Itanic, but then that seems to be dying fast.

The cpu needs to have an RMW instruction that does something to a
variable relative to a register that points to the per cpu base.

Thats generally possible. The problem is how expensive the RMW is going to
be.

