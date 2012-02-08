Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2BHRLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:11:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60302 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab2BHRLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:11:35 -0500
Date: Wed, 8 Feb 2012 17:12:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Scott Wood <scottwood@freescale.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>, KVM list <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Message-ID: <20120208171249.1b1eb5d0@pyramind.ukuu.org.uk>
In-Reply-To: <4F32AAA7.2040203@freescale.com>
References: <4F2AB552.2070909@redhat.com>
	<CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>
	<4F2C6517.3040203@codemonkey.ws>
	<4F302E0D.20302@freescale.com>
	<4F3118EA.7040302@codemonkey.ws>
	<4F32AAA7.2040203@freescale.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the fd overhead really is a problem, perhaps the fd could be retained
> for setup operations, and omitted only on calls that require a vcpu to
> have been already set up on the current thread?

Quite frankly I'd like to have an fd because it means you've got a
meaningful way of ensuring that id reuse problems go away. You open a
given id and keep a handle to it, if the id gets reused then your handle
will be tied to the old one so you can fail the requests.

Without an fd it's near impossible to get this right. The Unix/Linux
model is open an object, use it, close it. I see no reason not to do that.

Also the LSM hooks apply to file objects mostly, so its a natural fit on
top *IF* you choose to use them.

Finally you can pass file handles around between processes - do that any
other way 8)

Alan
