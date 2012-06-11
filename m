Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2FKOkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:40:51 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:34365 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751632Ab2FKOku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:40:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5yEh4gMVM1kCNI26biu63anPH.ssYY1tjNGQjkMfIyBsIxG
 d_K3nzT1dXEpkSQwUwUYDKI0GHZzC2KHcNPztgQ3zKHZ1ReC00uPKiJMrCmG
 otghWBjgsRbZg78ScAUQ3zpC7KLuDKS3cA9rkOdgdLjZtYrukp0NqNRnBSnz
 2tqYaCqzkXT.PIavTENpboK2kK8Bj53AVNlXJOJFKDUZI0wX8WSf96NoMJcQ
 hK8g6d1WupH94VC_0103mmNrqZ4UNwG_8qS_iUjerX4zBlY6sTslGJSSiLEi
 oXc3KoA5L8oRGAPoqYmujUctF8Hzdyg0zIpdgfg5C3Z2v_VveCpoDh0XGPPg
 G144bjEj_oSmdcjGkwsE_Q6Y6AiJUqblDM8ib_MQ9VPz18SWRi2W1XwzugBx
 JFl9F.TRjZlyV5AXQwz8iBcLjL50VFAw0_HPW
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 09:40:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
In-Reply-To: <4FD60127.1000805@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206110937430.31180@router.home>
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1206110856180.31180@router.home> <4FD60127.1000805@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, KOSAKI Motohiro wrote:

> On 6/11/2012 10:02 AM, Christoph Lameter wrote:
> > On Mon, 11 Jun 2012, kosaki.motohiro@gmail.com wrote:
> >
> >> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >>
> >> commit 2244b95a7b (zoned vm counters: basic ZVC (zoned vm counter)
> >> implementation) broke protection column. It is a part of "pages"
> >> attribute. but not it is showed after vmstats column.
> >>
> >> This patch restores the right position.
> >
> > Well this reorders the output. vmstats are also counts of pages. I am not
> > sure what the difference is.
>
> No. In this case, "pages" mean zone attribute. In the other hand, vmevent
> is a statistics.

The vmevent countes are something different from the zone counters. Event
counters are indeed statistics only but the numbers here were intended
to be are actual counts of pages. Well some of them like the numa_XXX are
stats you are right. Those could be moved off the ZVCs and become event
counters.

> > You are not worried about breaking something that may scan the zoneinfo
> > output with this change? Its been this way for 6 years and its likely that
> > tools expect the current layout.
>
> I don't worry about this. Because of, /proc/zoneinfo is cray machine unfrinedly
> format and afaik no application uses it.

Cray? What does that have to do with it.

> btw, I believe we should aim /sys/devices/system/node/<node-num>/zones new directory
> and export zone infos as machine readable format.

Yes that would be a good thing.
