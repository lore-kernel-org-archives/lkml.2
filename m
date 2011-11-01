Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1KABiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:38:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1KABiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:38:05 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=D8-pIz8dYmQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gu6fZOg2AAAA:8 a=Vwkkof6LtH_gJOwyVZIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320111482.4793.23.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: fix event_subsystem ref counting
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 31 Oct 2011 21:38:02 -0400
In-Reply-To: <4EAF476C.2060900@cn.fujitsu.com>
References: <1320052062-7846-1-git-send-email-idryomov@gmail.com>
	 <1320077699.4793.5.camel@gandalf.stny.rr.com>
	 <4EAF476C.2060900@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 09:12 +0800, Li Zefan wrote:
> Steven Rostedt wrote:
> > On Mon, 2011-10-31 at 11:07 +0200, Ilya Dryomov wrote:
> >> Fix a bug introduced by e9dbfae5, which prevents event_subsystem from
> >> ever being released.
> >>
> >> Ref_count was added to keep track of subsystem users, not for counting
> >> events.  Subsystem is created with ref_count = 1, so there is no need to
> >> increment it for every event, we have nr_events for that.  Fix this by
> >> touching ref_count only when we actually have a new user -
> >> subsystem_open().
> > 
> > Good catch, I'll pull this in.
> > 
> 
> I made a different fix last week:
> 
> http://marc.info/?l=linux-kernel&m=131978486911595&w=2
> 
> but I guess Ilya's version is a bit better.

That patch was still in my queue to process, as I missed it during my
travels to Prague. But yeah, I think Ilya's patch is a better solution.

Thanks!

-- Steve



