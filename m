Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1GLVgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:36:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53224 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1GLVgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110712212920.GQ2326@linux.vnet.ibm.com>
References: <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
	<20110710171626.GK6014@linux.vnet.ibm.com>
	<20110710173530.GA16954@linux.vnet.ibm.com>
	<CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
	<20110710214639.GP6014@linux.vnet.ibm.com>
	<CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
	<20110710231449.GQ6014@linux.vnet.ibm.com>
	<CAAVPGOMSprJSkzziH6hJv9PweOONzsMaRZEK2ZSrV3xFBReTPw@mail.gmail.com>
	<20110711214301.GP2245@linux.vnet.ibm.com>
	<CAAVPGOOJ0NEWqF2w9zCLC1bpXeA_TwzenNo-a4kvR3tcbewnNw@mail.gmail.com>
	<20110712212920.GQ2326@linux.vnet.ibm.com>
Date: Tue, 12 Jul 2011 22:35:58 +0100
Message-ID: <CAAVPGOPEjBVgv=oxJr1nptiFT8fGtED7qHicz7zaY8LUbiVi_w@mail.gmail.com>
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
From: Julie Sullivan <kernelmail.jms@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> OK tested- jms.2011.07.11a fails. The other one's fine (I'm actually
>> running an -rc6 with its patches right now :-)
>
> Just to make sure I understand what patch you are using...  Is it the
> one that I have listed below?  It would be bad form for me to send the
> wrong patch upstream.  ;-)


Yep, that's the one :-)


>
> If this is the correct one, then the upstreamable patch I sent recently
> (https://lkml.org/lkml/2011/7/12/313) should also work.  Famous last
> words...
>

Just compiling that one now....


>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: prevent RCU callbacks from being invoked during early boot.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index dbe4120..4456395 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1476,7 +1476,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>  */
>  static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
>  {
> -       if (likely(!rsp->boost)) {
> +       if (likely(rcu_kthreads_spawnable && !rsp->boost)) {
>                rcu_do_batch(rsp, rdp);
>                return;
>        }
>
