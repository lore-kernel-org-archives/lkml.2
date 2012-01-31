Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2AaLxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:53:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55905 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2AaLx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:53:28 -0500
Date: Tue, 31 Jan 2012 11:54:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <greg@kroah.com>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: sysfs regression: wrong link counts
Message-ID: <20120131115447.759d72b1@pyramind.ukuu.org.uk>
In-Reply-To: <m1mx94cz7d.fsf@fess.ebiederm.org>
References: <4F27120A.4040106@suse.cz>
	<20120130220611.GA26655@kroah.com>
	<20120130221059.26ab5edf@pyramind.ukuu.org.uk>
	<m1mx94cz7d.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 19:45:10 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> Isn't there some other "proper" way of doing this in userspace, or is
> >> this really the correct way?
> >
> > You can look at the S_IFMT bits and stuff however link count indicating
> > number of subdirectories is a standard Unix thing and used by many quite
> > mundane tools as an optimisation.
> 
> Those tools for a decade or better all know to treat nlink == 1 as the
> case where the optimization does not apply.

Most of the do. but as has been demonstrated here - not all
