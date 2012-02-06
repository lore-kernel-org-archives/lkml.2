Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2BFIK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:10:58 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:26370
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751087Ab2BFIK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:10:57 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH 07/07] ONKEY: OnKey module for DA9052/53 PMIC v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA5AA@KCHJEXMB02.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA5AA@KCHJEXMB02.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 6 Feb 2012 13:32:17 +0530
Message-ID: <1328515337.30549.22.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 19:33 +0530, Ashish Jangam wrote:
> > > That doesn't seem to address the concern.  You're setting ret in 
> > > exactly one place and scheduling the work in exactly one place,
> why
> >> are these two things split?
> 
> > schedule_delayed_work() is conditional because it should get invoke 
> > when onkey button is pressed and not when released. For this reason 
> > onkey event is first queried and work is scheduled only when event
> is 
> > present. Now when work is scheduled, onkey event gets queried and
> in 
> > absence of the onkey event work will not get schedule again. By this
> > logic I'm able to simulated the release of the onkey button.
> 
> You're once more completely missing my point.  You've got a
> conditional which detects if the button is pressed in which you set a
> flag which is checked later to see if you should also schedule the
> work.  Since the only thing that ever sets that flag is the button
> being pressed having the flag seems pointless, you may as well just
> schedule  the work instead of setting the flag.
Do you meant to have something like below
if(..) {
} else {
	ret =  ret &  DA9052_EVENTB_ENONKEY;
	input_report_key(.., ret);
	...
	schedule_delayed_work(..);
}
/*
if(ret)
	schedule_delayed_work(..);
*/
but this turns out to be a for ever loop.


