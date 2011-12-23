Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1LWUo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:44:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51010 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1LWUo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:44:26 -0500
Date: Fri, 23 Dec 2011 20:44:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: Print PCI device in power management warning.
Message-ID: <20111223204407.54363939@pyx>
In-Reply-To: <20111223181626.GA18647@redhat.com>
References: <20111223181626.GA18647@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 13:16:26 -0500
Dave Jones <davej@redhat.com> wrote:

> When the WARN_ON in pci_has_legacy_pm_support() triggers, we get
> users filing backtraces, but it's not obvious which driver is
> triggering the trace. This adds a printk before the BUG.
> This still isn't perfect (automated tools like abrt will still miss it)
> but we can at least ask the user to look through their dmesg when
> we get these traces reported.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

NAK

The old code did a WARN() the new code BUG() which in practice means in
many cases the user will get a crash and hang at boot and not even be
able to catch the trap.

At the very least your changelog should warn people it changes from
WARN_ON noise to system crash and burn.

Alan
