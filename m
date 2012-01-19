Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab2ASQEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:04:43 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35034 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2ASQEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:04:41 -0500
MIME-Version: 1.0
From: Tomer Margalit <tomermargalit@gmail.com>
Date: Thu, 19 Jan 2012 18:04:19 +0200
Message-ID: <CAG3n4CS5vyx2sn9t0geQoxa+kE+Nk9Q-0fwTCU6o9iQ33bORjA@mail.gmail.com>
Subject: Failing a bio right
To: linux-kernel@vger.kernel.org
Cc: Nezer Zaidenberg <nzaidenberg@mac.com>,
        tomer Margalit <tomermargalit@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have a make_request function that blocks writes (by using
wait_event_interruptible on some event).
I want the user to be able to stop the function if it takes too long
(that's the reason for the interruptible version).
So when the call is interrupted I call bio_endio with the EINTR error
to signal the interruption.
Usually this works fine, but after a lot of writes, the system says
"lost page write due to I/O error on device".
At this point the process hangs.

Is this the right way to do what I'm trying to do?

Thanks,
   Tomer
