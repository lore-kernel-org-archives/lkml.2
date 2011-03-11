Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab1CKSvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:51:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43122 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1CKSvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:51:32 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1JSC8Zogx6oCcTooWtcA:9 a=5MCM3AF_gMplxGXQLYzRXU5amSsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernel git bisect question
From: Steven Rostedt <rostedt@goodmis.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mark Hounschell <markh@compro.net>,
        Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110311183711.GA559@merkur.ravnborg.org>
References: <4D793414.4090206@compro.net>
	 <20110310215438.GE12521@home.goodmis.org> <4D7A6A99.5070304@compro.net>
	 <20110311183711.GA559@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 11 Mar 2011 13:51:30 -0500
Message-ID: <1299869490.9910.49.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 19:37 +0100, Sam Ravnborg wrote:
> On Fri, Mar 11, 2011 at 01:31:53PM -0500, Mark Hounschell wrote:
> > On 03/10/2011 04:54 PM, Steven Rostedt wrote:
> > > On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
> > >> Between git bisect [good | bad ]s should I always "make clean" or can I
> > >> count on the build system to take care of everything properly?
> > > 
> > 
> > I'm trying to bisect between 2.6.35 and 2.6.36. What have I done wrong?
> > Here is exactly what I've done. Why after my second "git bisect bad" do
> > I get a Makefile for 2.6.35-rc1 and then after the fourth I get a Makefile
> > for 2.6.34??
> 
> The development is not linear.
> So you see a commit developed on top of 2.6.34 that was included in 2.6.35.
> This is normal.

Right.

Mark, don't be embarrassed, this is a common question for those that
start using git bisect. Because of the way git merges branches, you may
end up in an old version of a kernel, while looking between two newer
versions.



    v2.6.36
        |
        +
        |\
        | \
v2.6.35 +  \
        |   +---- developers branch
        |  /
        | /
        |/
        +--- v 2.6.34
        |

If a developer branched off of 2.6.34 and then his work got merged after
v2.6.35, your bisect may easily go into that developers branch between
2.6.35 and 2.6.36, where you will suddenly see 2.6.34 appear and
disappear within bisect iterations. IOW, don't trust what you see in the
Makefile ;)

Understand?

-- Steve




