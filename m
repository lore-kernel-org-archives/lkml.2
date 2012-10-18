Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2JRJ1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:27:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39896 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755000Ab2JRJ1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:27:19 -0400
Message-ID: <1350552439.3072.65.camel@joe-AO722>
Subject: Re: [PATCH v3 1/1] Input: serio - Add ARC PS/2 driver
From: Joe Perches <joe@perches.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "m.d.s.x.jonker@gmail.com" <m.d.s.x.jonker@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Date: Thu, 18 Oct 2012 02:27:19 -0700
In-Reply-To: <E6BF041E97966E4DB955F0DF883AD2D6019A63@DE02WEMBX1.internal.synopsys.com>
References: <1350549367-11098-1-git-send-email-mischa.jonker@synopsys.com>
	 <1350549367-11098-2-git-send-email-mischa.jonker@synopsys.com>
	 <1350550916.3072.61.camel@joe-AO722>
	 <E6BF041E97966E4DB955F0DF883AD2D6019A63@DE02WEMBX1.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 09:05 +0000, Mischa Jonker wrote:
> Hi Joe,
> 
> >> +	while (1) {
> >infinite loop with bad hardware?
> >Perhaps a jiffies timeout?
> 
> What do you suggest? Add a counter and limit the maximum number of iterations to an arbitrary number (say 1000)?

Yes, something like that.
Or something like:

	unsigned long timeout = jiffies + somevalue;
	while (time_before(jiffies, timeout) {
		etc...
	}

cheers, Joe

