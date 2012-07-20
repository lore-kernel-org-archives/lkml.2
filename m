Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2GTPxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:53:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52191 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2GTPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <4071247.4LoKycnIHi@linux-lqwf.site>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
	<4071247.4LoKycnIHi@linux-lqwf.site>
Date: Fri, 20 Jul 2012 23:53:02 +0800
Message-ID: <CACVXFVOarPfL0-PyZciwx7n4QTy+pji2VKFrCp6B3niU2M_X2w@mail.gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
From: Ming Lei <tom.leiming@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 9:54 PM, Oliver Neukum <oneukum@suse.de> wrote:

>
> The approach seems to me to be less comprehensive than
> it ought to be. If you defer, why not the whole probe()?

Because for other failures, we don't know when the conditions
for them can be satisfied. For example, we don't know when the
memory allocation can be met for one previous allocation failure.

IMO, at least the approach provides one simple way to solve the
firmware loading problem during. early boot or resume

> Deferring only the upoad of the firmware complicates
> error handling.

Looks there is no special requirement for the error handling of
request_firmware, just like other failures' handling, undo things
which has been done, isn't there?

Thanks,
-- 
Ming Lei
