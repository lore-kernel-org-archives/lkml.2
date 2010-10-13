Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0JMC25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 22:28:57 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56390 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0JMC24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 22:28:56 -0400
Message-ID: <4CB51922.2080405@dcl.info.waseda.ac.jp>
Date: Wed, 13 Oct 2010 11:27:46 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Vojtech Pavlik <vojtech@ucw.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] lockdep: check the depth of subclass
References: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1286879221.29097.39.camel@twins> <20101012160352.GB30513@core.coreip.homeip.net>
In-Reply-To: <20101012160352.GB30513@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/10 01:03, Dmitry Torokhov wrote:
 > On Tue, Oct 12, 2010 at 12:27:01PM +0200, Peter Zijlstra wrote:
 >> On Tue, 2010-10-05 at 18:01 +0900, Hitoshi Mitake wrote:
 >>> ---
 >>>   drivers/input/mousedev.c |    2 +-
 >>>   kernel/lockdep.c         |   15 +++++++++++++++
 >>>   2 files changed, 16 insertions(+), 1 deletions(-)
 >>>
 >>> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
 >>> index d528a2d..9897334 100644
 >>> --- a/drivers/input/mousedev.c
 >>> +++ b/drivers/input/mousedev.c
 >>> @@ -866,7 +866,7 @@ static struct mousedev *mousedev_create(struct 
input_dev *dev,
 >>>   	spin_lock_init(&mousedev->client_lock);
 >>>   	mutex_init(&mousedev->mutex);
 >>>   	lockdep_set_subclass(&mousedev->mutex,
 >>> -			     minor == MOUSEDEV_MIX ? MOUSEDEV_MIX : 0);
 >>> +			     minor == MOUSEDEV_MIX ? SINGLE_DEPTH_NESTING : 0);
 >>
 >> Ah good find.
 >>
 >
 > I'll pick up mousedev change for .37.

Thanks a lot, Dmitry.

Should I divide this patch into two for
drivers/input/mousedev.c and kernel/lockdep.c?
If you need, I'll resend second version.
