Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032193Ab2CPXI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:08:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53926 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031499Ab2CPXIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:08:54 -0400
Date: Fri, 16 Mar 2012 23:07:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Du, Alek" <alek.du@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Message-ID: <20120316230720.17936ac2@pyx>
In-Reply-To: <4F632C15.5070902@suse.cz>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
	<20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
	<09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
	<4F630B4D.3040508@suse.cz>
	<09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com>
	<4F630E6D.4000307@suse.cz>
	<09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com>
	<4F63101D.70507@suse.cz>
	<09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com>
	<4F631449.7090302@suse.cz>
	<09F19C497AD02E4EA4E14917772649B70FCD3DCC@SHSMSX102.ccr.corp.intel.com>
	<4F632C15.5070902@suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or maybe even removing that interface completely...

We should be able to fix that interface fairly simply. If you have a
completed call then you can mark the buffer not to be freed and only
reap it post flush on the completed call.

Once the BKL remnants are gone we can hold tty->ldisc_mutex over ldisc
receive paths at which point this can be turned into a sane API.

Alan
