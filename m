Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab1IIRla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:41:30 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:56896 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1IIRl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:41:29 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEUTjZbxesiKFzGE4a9rs-GQfq1ekzaDAv34pMGrEQAUcg@mail.gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	<CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
	<CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
	<CANejiEX=S8tyPDhAjm84+9xBNt08Q0mjWHjqh-kFqL4H1ME-RA@mail.gmail.com>
	<CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
	<CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
	<CA+X1aCR6Rptj_7bKf7O7TJ8a9z7AH0vXL90XAgY=+054WegsgQ@mail.gmail.com>
	<CANejiEUTjZbxesiKFzGE4a9rs-GQfq1ekzaDAv34pMGrEQAUcg@mail.gmail.com>
Date: Fri, 9 Sep 2011 21:41:28 +0400
Message-ID: <CA+X1aCQhUALGLrtjSzdHonQ1WdPgVMPa7kW2Yi0UFqBwD0Vv6w@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: Shaohua Li <shli@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua,

> So the key problem here is how to detect if a device is fast. Doing
> the detection
> in the dispatch stage always can't give us correct result. A fast device really
> should be requests can be finished in short time. So I have something attached.
> In my environment, a hard disk is detected slow and a ssd is detected fast, but
> I haven't run any benchmark so far. How do you think about it?

Thanks for the patch, I'll test it in several h/w configurations soon
and let you know about results.

As a first thought that comes to mind, this patch would hardly meet
needs of h/w raids. Every particular hdd may be not very fast, but
being assembled in RAID-0, it's still very beneficial to submit many
requests in a row. That's why I made estimation in the dispatch stage:
if hdd (or h/w raid) is regularly able to drain deep queue quite fast,
we should claim it as 'fast' and avoid idling if possible.

Thanks,
Maxim
