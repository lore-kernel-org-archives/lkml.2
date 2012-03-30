Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab2C3Kby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:31:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47549 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310Ab2C3Kbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:31:47 -0400
Date: Fri, 30 Mar 2012 11:34:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Du, Alek" <alek.du@intel.com>, "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH v2] tty: hold lock across tty buffer finding and buffer
 filling
Message-ID: <20120330113407.7cbeaef6@pyramind.ukuu.org.uk>
In-Reply-To: <EE928378561BF1449699C96571234A740FCCE410@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCC5EC3@SHSMSX102.ccr.corp.intel.com>
	<20120316201445.GA1240@kroah.com>
	<EE928378561BF1449699C96571234A740FCCE410@SHSMSX102.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 10:26:27 +0000
"Tu, Xiaobing" <xiaobing.tu@intel.com> wrote:

> Hi Greg
>   Even there still a prepare buffer not protected, the patch is still good to protect rest case, so this patch is still "nice to have"
> it makes the situation better. for the not-fixed case, we can have another patch to address that. Do you agree?

Can't speak for Greg (who I suspect is busy with the merge window to
Linus) but I think this is the right thing to do once the merge window is
over.  The unfixed case needs other things to happen first, such as the
removal of tty_lock/tty_unlock. At that point much of this should become
much simpler.

Alan
