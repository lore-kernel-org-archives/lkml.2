Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423150Ab2CPQcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:32:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56460 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422762Ab2CPQcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:32:17 -0400
From: Oliver Neukum <oliver@neukum.org>
To: santosh nayak <santoshprasadnayak@gmail.com>
Subject: Re: [PATCH] [media] staging: Return -EINTR in s2250_probe() if fails to get lock.
Date: Fri, 16 Mar 2012 17:32:17 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org, khoroshilov@ispras.ru,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1331915038-11231-1-git-send-email-santoshprasadnayak@gmail.com>
In-Reply-To: <1331915038-11231-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203161732.17246.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 16. März 2012, 17:23:58 schrieb santosh nayak:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> In s2250_probe(), If locking attempt is interrupted by a signal then
> it should return -EINTR after unregistering audio device and making free
> the allocated memory.
> 
> At present, if locking is interrupted by signal it will display message
> "initialized successfully" and return success.  This is wrong.

Indeed there's a lot wrong here. The idea of having an interruptible
sleep in probe() is arcane. You need a very, very, very good reason for that.
The sane fix is using an uninterruptable sleep here.

Second, while you are at it, fix the error case for no initialization
due to a failing kmalloc(). You need to return -ENOMEM.

	Regards
		Oliver
