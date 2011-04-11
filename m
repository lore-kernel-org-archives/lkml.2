Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1DKQdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:33:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34716 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275Ab1DKQdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:33:37 -0400
Date: Mon, 11 Apr 2011 17:34:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Cc: Keith Packard <keithp@keithp.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
Message-ID: <20110411173409.1567679c@lxorguk.ukuu.org.uk>
In-Reply-To: <20110409000857.GB25581@piper>
References: <yun1v1fj024.fsf@aiko.keithp.com>
	<alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6>
	<alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6>
	<yunaag0tjzb.fsf@aiko.keithp.com>
	<20110409000857.GB25581@piper>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I took a shot at it and just sent a patch (also attached for convenience) 
> that should solve the problem.

Well its reverting too much but its also looking pretty bogus to me

-	/* Stop timer, it might be running */
-	del_timer_sync(&hdev->cmd_timer);
-
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		hci_req_unlock(hdev);
 		return 0;

So you've now got a path where you leave the timer running and didn't
before - not it appears one that is a good idea.

Certainly not the kind of change that should be considered for a
regression fix for an rc kernel. It's far too big a behavioural change to
be safe.

Alan
