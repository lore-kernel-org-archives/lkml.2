Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2KPOzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:55:01 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55964 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2KPOy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:54:58 -0500
Date: Fri, 16 Nov 2012 15:00:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jun Chen <jun.d.chen@intel.com>, serial <linux-serial@vger.kernel.org>,
        "russ.gorby" <russ.gorby@intel.com>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Bi Chao <chao.bi@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial: ifx6x60: Add module parameters to manage the
 modem status through sysfs
Message-ID: <20121116150007.273b7038@pyramind.ukuu.org.uk>
In-Reply-To: <20121116123806.GA9303@kroah.com>
References: <1353070789.24092.6.camel@chenjun-workstation>
	<20121116123806.GA9303@kroah.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 04:38:06 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Nov 16, 2012 at 07:59:49AM -0500, Jun Chen wrote:
> > 
> > The Medfield Platform implements a recovery procedure consisting in an escalation
> > from simple and light recovery procedures to stronger ones with increased visibility
> > and impact to end-user.After platform find some problem from Modem,such as no response,
> > platform will try do modem warm reset.If several tries failed, platform will try to
> > do modem cold boot procedure.For Modem Cold Boot, AP is responsible to generate
> > blob (binary object containing PIN code and other necessary information).
> > Blob is stored in AP volatile memory. AP decides to read PIN code from cache instead of
> > prompting end-user, and sends it to modem as if end-user had entered it.
> > 
> > This patch add module parameters to manage the modem status through sysfs.
> > Reset_modem can be read and write by user space.When read the reset_modem,user space will
> > get the mdm_reset_state which used to avoid to run twice at once.When set the reset_modem to
> > IFX_COLD_RESET_REQ,modem will do cold reset, other val value will trigger modem reset.
> > 
> > Hangup_reasons used to give one interface to user space to know and clear the modem reset reasons.
> > Now there are four reasons:SPI timeout, modem initiative reset,modem coredump,spi tranfer error.
> 
> Why are these module parameters?  Why not just "real" sysfs files
> instead?  That way, if you have multiple devices in a system, it will
> work properly for them.  Right now you are limited to 1 device, right?

Yes and its highly unlikely that there will ever be anyone who needs two.

Alan
