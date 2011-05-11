Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1EKQWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:22:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1EKQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:00 -0400
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
	 <1305109433.2914.208.camel@laptop>
	 <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
	 <1305121541.2914.213.camel@laptop>
	 <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 16:01:58 +0200
Message-ID: <1305122518.2914.224.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 15:52 +0200, Kay Sievers wrote:
> 
> No, fixed time spans have never been a problem, and are not the
> example here. It's about the normal wall clock, that wakes up every
> minute and updates the numbers on the screen. 

'wakes up every minute' sounds like a fixed time interval to me.

Anyway, I still don't agree with the current implementation, its adding
overhead to timer fast-paths for a definite slow-path.

