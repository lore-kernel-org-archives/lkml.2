Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2AQUI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:08:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50844 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2AQUIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:08:25 -0500
Date: Tue, 17 Jan 2012 20:09:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/3] serial: Make wakeup_capable a flag to reduce boot
 time
Message-ID: <20120117200942.7e7adf09@pyramind.ukuu.org.uk>
In-Reply-To: <1326826563-32215-2-git-send-email-sjg@chromium.org>
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
	<1326826563-32215-2-git-send-email-sjg@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 10:56:02 -0800
Simon Glass <sjg@chromium.org> wrote:

> The synchronize_rcu() call resulting from making every serial driver
> wake-up capable (commit b3b708fa) slows boot down by 600ms on my Tegra2x
> system (with CONFIG_PREEMPT disabled).
> 
> Waking up the machine from a serial port seems to be an unlikely
> requirement, so make serial_core default to not using the behaviour.

Its quite normal on x86, and very very common on embedded. Sorry someone
needs to fix the root cause not hack the driver.

The other question would be whether in PC space you can deduce the wake
up situation from ACPI data ? One for Len ?

Alan


