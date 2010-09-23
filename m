Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0IWPYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:24:08 -0400
Received: from isomail2.amdocs.com ([193.43.244.89]:49578 "EHLO
	isomail2.amdocs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0IWPYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:24:05 -0400
From: James Dingwall <james.dingwall@amdocs.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 23 Sep 2010 16:23:55 +0100
Subject: RE: Re: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after the
 boot
Thread-Topic: Re: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after
 the boot
Thread-Index: ActbBrFQRLxRr7otT6CQVQeRBMawqgAKvpTA
Message-ID: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-8.0.0.4125-6.500.1024-17660.007
x-tm-as-result: No--45.251400-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was experiencing the same immediate crash with a null pointer
> dereference (log below) on boot with 2.6.35.5.  Reverting
> fb412a178502dc498430723b082a932f797e4763 also resolved the problem for
> me.

Checking the diff from this commit it looks like there is a typo in the patch.  With the following (probably mangled by my client) I get 2.6.35.5 to boot.  Suggest it should be a candidate for .32 and .35 stable trees.

--- drivers/xen/events.c.orig   2010-09-23 16:10:34.257124313 +0100
+++ drivers/xen/events.c        2010-09-23 16:10:44.326194462 +0100
@@ -935,7 +935,7 @@
 	.retrigger		= retrigger_dynirq,
 };

-static struct irq_chip en_percpu_chip __read_mostly = {
+static struct irq_chip xen_percpu_chip __read_mostly = {
 	.name			= "xen-percpu",

 	.disable		= disable_dynirq,

James
This message and the information contained herein is proprietary and confidential and subject to the Amdocs policy statement,
you may review at http://www.amdocs.com/email_disclaimer.asp

