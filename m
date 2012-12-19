Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2LSBA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:00:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41384 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755342Ab2LSBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:00:55 -0500
Message-ID: <1355878854.2139.5.camel@joe-AO722>
Subject: Re: [rtc-linux] [RESEND PATCH] RTC: MAX77686: Add Maxim 77686 driver
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myugnjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Tue, 18 Dec 2012 17:00:54 -0800
In-Reply-To: <20121218163009.fb21fec8.akpm@linux-foundation.org>
References: <1354085457-18460-1-git-send-email-jonghwa3.lee@samsung.com>
	 <20121218163009.fb21fec8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 16:30 -0800, Andrew Morton wrote:
> On Wed, 28 Nov 2012 15:50:57 +0900
> Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> 
> > Add driver for support max77686 rtc.
> > MAX77686 rtc support smpl and wtsr mode. It has two alarm register
> > which can be used for alarming to wake system up. This drvier uses regmap
> > to access its register.
> > 
> > ...
> >
> > +static inline int max77686_rtc_calculate_wday(u8 shifted)
> > +{
> > +	int counter = -1;
> > +	while (shifted) {
> > +		shifted >>= 1;
> > +		counter++;
> > +	}
> > +	return counter;
> > +}
> 
> We should be able to use log2() in here?

	fls(shifted) - 1


