Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0IHHb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:31:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0IHHby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:31:54 -0400
Subject: Re: disabling group leader perf_event
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100908064427.GD3439@elte.hu>
References: <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu>
	 <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu>
	 <4C850147.8010908@redhat.com> <20100906154737.GA4332@elte.hu>
	 <4C852B2A.2030103@redhat.com> <20100907034417.GA14046@elte.hu>
	 <20100908014409.GA17010@brick.ozlabs.ibm.com>
	 <AANLkTi=YdAxdGv1nEEZ4w0jM0K3ss0g5x7_5cU8xNEhj@mail.gmail.com>
	 <20100908064427.GD3439@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 09:30:48 +0200
Message-ID: <1283931048.1930.1827.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 08:44 +0200, Ingo Molnar wrote:
> Thus instructions like 'mov (%rax), ...' would be handled by not 
> allowing them, only addresses which do not change from execution
> state.

> Do you know some interesting usecase that would be excluded via such 
> address restrictions? 

my_array[i] = foo;

usually ends up wanting to do something with a register offset.
