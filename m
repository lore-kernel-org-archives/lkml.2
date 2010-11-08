Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0KHKVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:21:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47994 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753339Ab0KHKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:21:36 -0500
Date: Mon, 8 Nov 2010 10:20:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH RFC] Restrictions on module loading
Message-ID: <20101108102013.0861725b@lxorguk.ukuu.org.uk>
In-Reply-To: <1289179439.3090.205.camel@Dan>
References: <1289179439.3090.205.camel@Dan>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> loading of kernel modules, for example by creating a socket using a
> packet family that is compiled as a module and not already loaded.  On
> most distributions, this creates a significant attack surface, and
> requires maintenance of blacklists and other inelegant solutions to a
> general problem.

Those inelegant solutions work rather better in a lot of situations
because most distributions will fall flat on their face if auto loading
isn't active and they are more flexible.

> The below patch replaces the existing "modules_disable" sysctl with a

NAK - Its a long standing ABI.

> When set to 2, modules may not be loaded or unloaded by anyone, and the
> sysctl may not be changed from that point forward.  This is designed to
> provide protection against kernel module rootkits.

I've no objection to modules_restrict although I doubt it'll ever get
used in the real world, but better to extend the meaning of the existing
interface, not remove stuff.

If you have "security" in your address the please think like a security
person - users with security relying upon writing to modules_disable are
*not* going to notice a one line log entry somewhere about unable to open
{filename that doesn't look important}.

So your change is actually *bad* for security in its current form, you
remove the facilities they rely upon.

Alan

