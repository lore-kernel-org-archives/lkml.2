Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2HUNkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:40:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55273 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2HUNkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:40:02 -0400
Date: Tue, 21 Aug 2012 14:44:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomas Hlavacek <tmshlvck@gmail.com>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.vasut@gmail.com
Subject: Re: [PATCHv4 1/1] [RFC] uartclk from serial_core exposed to sysfs
Message-ID: <20120821144439.2bfcfc8d@pyramind.ukuu.org.uk>
In-Reply-To: <CAEB7QLDBjUp9GswRB20KdFNVLJme3WeX2Xd79-ovP6SWxVORpA@mail.gmail.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
	<1345401285-14473-1-git-send-email-tmshlvck@gmail.com>
	<CAEB7QLDBjUp9GswRB20KdFNVLJme3WeX2Xd79-ovP6SWxVORpA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have updated the patch to a new v4 in order to remove the race in
> sysfs file creation and add sysfs file description to a Documentation
> directory. But still the patch creates the sysfs file separately for
> each serial TTY device by assigning attribute_groups to the struct
> device and not for the whole driver at once as Greg advised because I
> was unable to figure out how to do that (even though I tried pretty
> hard). Does it make sense like this? Or do you have any hint for a
> better way to do it, please?

I'm fine with it - dunno about GregKH. Given the way tty 'drivers' and
tty devices fit together I'm not 100% sure it makes sense to do it per
driver. Plus once we have the basis we can fix a lot of the detail
afterwards.

Alan
