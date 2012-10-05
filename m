Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2JELBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:01:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:52189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2JELBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:01:35 -0400
Message-ID: <1349434879.14388.35.camel@twins>
Subject: Re: [RFC] perf: perf_event_attr anon unions and static initializer
 issue
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 05 Oct 2012 13:01:19 +0200
In-Reply-To: <CABPqkBRCjd5=9t1URNXQvu8GbAHMjf3ixKtb6BV7ebBTZDLF1A@mail.gmail.com>
References: <CABPqkBRCjd5=9t1URNXQvu8GbAHMjf3ixKtb6BV7ebBTZDLF1A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 12:36 +0200, Stephane Eranian wrote:

> struct perf_event_attr attr = { .config = 0x1234, .config1 = 0x456 };

> Does anyone have a better solution to propose?


  struct perf_event_attr attr = { 
	.config = 0x1234, 
	{ .config1 = 0x5678 },
  };

sometimes works, but apparently not in this case.. its a bit unfortunate
indeed. EDG based compilers and the latest C std use your version --
hence also 4.6 supporting it.

Yeah, I'm afraid we're stuck with this until a future where modern C
isn't modern anymore.
