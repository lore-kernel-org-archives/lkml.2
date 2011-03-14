Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1CNN2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:28:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab1CNN2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:28:21 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=22b6r0FicaIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=x0MeJVZhw77YE-MwEPYA:9 a=ofT5AGmqT6I7owaOsfDfU8Oxd4kA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3]trace-cmd: remove dead code
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D7D7DCD.7010200@cn.fujitsu.com>
References: <4D78A0A4.1040001@cn.fujitsu.com>
	 <1299768818.15854.343.camel@gandalf.stny.rr.com>
	 <4D7D7DCD.7010200@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 09:28:18 -0400
Message-ID: <1300109298.9910.66.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 10:30 +0800, Lai Jiangshan wrote:
> On 03/10/2011 10:53 PM, Steven Rostedt wrote:
> > On Thu, 2011-03-10 at 17:57 +0800, Lai Jiangshan wrote:
> >> filter_cpu related code is totally dead.
> > 
> > I'll rephrase this, as it is not dead. "dead" code is code that can not
> > be reached. This code most certainly can be reached. You may think it is
> > silly code, which it may be. The reason for the separation of one CPU
> > and multiple CPUs, is I do one CPU more often than I filter multiple,
> > and I wanted the 1 cpu to still be efficient.
> > 
> 
> I'm confused, filter_cpu is always -1, how the code can be reached?

Ah, you're right. Because of a bug:

-	if (filter_cpu)
+	if (filter_cpu >= 0)
		add_cpu(optarg);
	else
		filter_cpu = atoi(optarg);

Was what it was suppose to be.

-- Steve


