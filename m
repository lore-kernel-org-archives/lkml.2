Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1FHPod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:44:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60569 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756421Ab1FHPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:44:32 -0400
Date: Wed, 8 Jun 2011 16:46:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Toby Gray <toby.gray@realvnc.com>
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: Prevent loss of data when filling tty
 buffer
Message-ID: <20110608164626.22bc893c@lxorguk.ukuu.org.uk>
In-Reply-To: <1307547519-29246-1-git-send-email-toby.gray@realvnc.com>
References: <1307547519-29246-1-git-send-email-toby.gray@realvnc.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds checking for how many bytes have been inserted into the tty
> buffer and places data which hasn't been inserted into a pending buffer list.
> The pending buffer list is pushed to the tty buffer when the tty unthrottles

I don't think this is the way to tackle it.

If the kernel tty buffer code is shedding data then not only have we
asserted a throttle but 64K has been accumulated or the system is out of
memory.

So the questions to me are:

a) Why is your setup filling 64K in the time it takes the throttle
response to occur

b) Do we care (is the right thing to do to lose bits anyway at that point)

c) What should we do about it in the *general* case


It seems to me either its a cdc-acm specific problem with throttle
response behaviour, or its a general case at very high speed (which seems
more likely). In neither case is adding an extra queue to paper over it
the right solution.


