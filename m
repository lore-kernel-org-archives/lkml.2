Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab0E1Qot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:44:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41756 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab0E1Qor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Yzuu82UXt8MDqQamZJ9mF0i+cqnuMQurpKWJoQZp9Wm/oY1BaSu0ffy7uoaXqwoG1g
         T2tvDoPzuzg3GKQ/1OzpYn3IqrTUhW21DUOcJCQ/nANpxUktzU7uPbID1bTdMQ6KR5Ll
         BkZJQix2TFI4u13mFqwlGuN/b+KRwDISm4Aj0=
MIME-Version: 1.0
Date: Fri, 28 May 2010 11:44:46 -0500
Message-ID: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
Subject: wait_even_interruptible_timeout(), signal, spin_lock() = system hang
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this sequence of calls, system hangs (smp, x86 box based with
.34 kernel), can ping only.
I have not been able to break in with Alt Sysrq t, working on that

        rc = wait_event_interruptible_timeout(ses->server->response_q,
                        (midQ->midState != MID_REQUEST_SUBMITTED), timeout);
        if (rc < 0) {
                cFYI(1, ("command 0x%x interrupted", midQ->command));
                return -1;
        }

and when function that invoking function after coming out with ERESTARTSYS
(I kill the command with Ctrl C) calls
 spin_lock(&GlobalMid_Lock);

system hangs.  If I sleep before return -1 (e.g. msleep(1), no hang)

I do not have to use wait_event_interruptible_timeout and no such problems with
wait_event_timeout, it is only when signal/interrupt is involved, I
run into this problem

Any pointers/ideas what could be happening, would be really really appreciated.

Regards,

Shirish
