Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab2EYCwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:52:13 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:60027 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755657Ab2EYCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:52:12 -0400
Message-ID: <4FBEF3D7.60505@tao.ma>
Date: Fri, 25 May 2012 10:52:07 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: peterz@infradead.org, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sha <handai.szj@gmail.com>
Subject: 3.4: nohz load accounting still has some problem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
	With 3.4 we still has problems with nohz load accounting. In one of our
product system, the number of running processes is around 16, but
loadavg is only around 8-10.  Without your fix c308b56b5, it is only
less than 1... Your patch does work, but not good enough. :(

After some investigation, it seems that we still have a hole, but we and
not sure and haven't figure out how to resolve it. So maybe you have a
good idea of whether our analysis is good and how to fix it.

So in general after your fix c308b56b5, we will fold the nohz remainder
to the global one after all the cpu has calculated the real value. But
there does exist some case: See
cpu 0     1                        2
    calc  calc

          idle and update
          calc_load_tasks_idle

                                   calc

Now when cpu2 calculates load, it will use calc_load_tasks_idle which
has been changed by cpu1. So the load isn't accurate any more. Am I
missing something here?

Thanks
Tao
