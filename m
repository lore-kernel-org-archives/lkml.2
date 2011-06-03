Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1FCOij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:38:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44980 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1FCOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=goizTovRW4TTEPKidS7PLpWX5N8JooVfSOqRnfUD3sw5xdb1cuB/qIvcFRL9tlSMZD
         XV6gLcc4lehULNAfHGaCO0lu28EthceKwTNVi2HtYeISZ+SPF2EuV2GpopblsCGXvtV/
         5lK4C1EK/kLV3jFZQ05Kz7A6NUlWu8ee5R+iw=
MIME-Version: 1.0
In-Reply-To: <1307015789.2497.640.camel@laptop>
References: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
	<1307015789.2497.640.camel@laptop>
Date: Fri, 3 Jun 2011 22:38:36 +0800
Message-ID: <BANLkTinoiKq-rJ989cakwLmbO6zqSmLMgg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix conflict of schedule domain balance in RT scheduling
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 7:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-06-01 at 21:58 +0800, Hillf Danton wrote:
>> SD_BALANCE_WAKE and SD_WAKE_AFFINE are defined to be mutually
>> exclusive
>
> Uhm, no they're not.. both affect placement of a woken task but they're
> complementary. WAKE_AFFINE is a check to see if it makes sense to run
> the woken task on the same cpu as the wakee, BALANCE_WAKE does a full
> load-balance pass,

Though I dont understand the following, my question is why WAKE_AFFINE is
eligible for pushing RT tasks off the RQ on which they are waiting.

thanks
           Hillf

>in case its combined with WAKE_AFFINE it does so in
> case that test is negative.
>
