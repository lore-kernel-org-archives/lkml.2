Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0KODmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:42:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0KODmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:42:04 -0500
Date: Sun, 14 Nov 2010 20:42:37 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
Message-ID: <20101114204237.7cd9e1de@lembas.zaitcev.lan>
In-Reply-To: <Pine.LNX.4.44L0.1011142159090.4076-100000@netrider.rowland.org>
References: <20101114162502.6d6318e7@lembas.zaitcev.lan>
	<Pine.LNX.4.44L0.1011142159090.4076-100000@netrider.rowland.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010 22:01:58 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > + * This is the look-ahead pass in case of 'Ci', when actual_length cannot
> > + * be used to determine the length of the whole contiguous buffer.
> 
> Shouldn't the comment say "Cz" instead of "Ci"?

Turned out it's actually "C Zi".

> > +	while (ndesc-- != 0) {
> > +		if (fp->status == 0 && fp->actual_length != 0) {
> 
> I'd leave out the fp->status == 0 test.  It's not relevant; a buffer 
> can contain valid data even if the final status isn't 0.

That's a good point, however is actual_length filled in such case?
I thought it was either one or the other.

-- Pete
