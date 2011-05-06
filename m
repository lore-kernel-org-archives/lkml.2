Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1EFWZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:25:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38866 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442Ab1EFWZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:25:48 -0400
Date: Fri, 6 May 2011 23:26:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: <akpm@linux-foundation.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <allen.kao@atheros.com>,
        <roman.gezikov@atheros.com>, <joonas.viskari@atheros.com>
Subject: Re: [RFC 1/2] misc: add Atheros ar1520 GPS support
Message-ID: <20110506232638.72e8900a@lxorguk.ukuu.org.uk>
In-Reply-To: <1304719780-27347-2-git-send-email-lrodriguez@atheros.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
	<1304719780-27347-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last time this driver came up the answer was that the userspace was
proprietary and this was in fact part of a mixed user/kernel driver which
seemed to raise all sorts of interesting questions.

This was NAKked before for that reason so why the resubmit. Kernel policy
is clear enough ?

> + * You need a userspace application to cooperate with this driver. It and
> + * more information about this driver can be obtained here:
> + *
> + * http://wireless.kernel.org/en/users/Drivers/ar5120

Which says:

Userspace application

This driver requires a userspace application which will interact with the
driver via ioctl. More information on this to be posted later. 

So NAK


Let's see an open userspace and then this driver can be submitted

+		time =
  wait_event_interruptible_timeout(ar1520_data->wait_irq,
+
  ar1520_data->irq_rx, +
  msecs_to_jiffies(3142));

Why 3142 ?

Come to think of it why not fixes the races while you are it.

Alan
