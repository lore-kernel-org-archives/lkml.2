Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab2DLGQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:16:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62325 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2DLGQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:16:06 -0400
MIME-Version: 1.0
Date: Thu, 12 Apr 2012 08:16:04 +0200
Message-ID: <CAF1_xX205BcA_r77UhxXNYw1YwUAnTvHUAO7ONfioZ38KdRq9Q@mail.gmail.com>
Subject: genirq,x86_64: Genirq patch (b4bc724e82) makes Compaq Presario V6000
 hang during boot
From: Ronald <ronald645@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me as I'm not subscribed to this list.

Recently I found out that my laptop hangs during boot with recent kernels.
It began with stable 3.2.9 and then I confirmed that with 3.3.1 had
the same issue.
Using git I tried the latest head of a few days ago (f4e52e7ffde)
which also hanged.
Reverting the following patch fixes the issue for me on all versions.


commit b4bc724e82e80478cba5fe9825b62e71ddf78757
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Feb 8 11:57:52 2012 +0100

    genirq: Handle pending irqs in irq_startup()

    An interrupt might be pending when irq_startup() is called, but the
    startup code does not invoke the resend logic. In some cases this
    prevents the device from issuing another interrupt which renders the
    device non functional.

    Call the resend function in irq_startup() to keep things going.

    Reported-and-tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Cc: stable@vger.kernel.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


I have attached my .config [1] and a photo of the latest hanging kernel [2]
which is post 3.4 rc-2 by now (f549e088b80). I also attached a correctly
working dmesg of current head (again f549e088b80) with the offending
patch reverted [3].

So I opened a bug for this in the bugtracker [4]. So far there has
been no response,
so I suppose I classified it incorrectly.
Sorry for that.

Therefore I'm posting this message here to notify you of my
incorrectly placed bugreport.
And for suggestions on how to proceed. The kernel reliably hangs and I don't see
any output. Using SYSRQ does not help either.

Please, if the correct people are already aware of this bug then
ignore this mail.
And sorry for the noise. I'm still sending this since I believe this
is quite important
and should be fixed before the final release. Again, sorry for the
noise if this mail
is superfluous.

[1] http://pastebin.com/fvWAqmqv
[2] http://tinypic.com/view.php?pic=2uif21j&s=5
[3] http://pastebin.com/QmMA6hGS
[4] https://bugzilla.kernel.org/show_bug.cgi?id=43069

                                         Ronald
