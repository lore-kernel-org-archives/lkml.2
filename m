Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0IMLi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:38:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64805 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab0IMLi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aH4pvk2iB7+C0Ui5r4QKB9wqoVUtfQI64InaQNxr47qyCA6LmUq+GV8w2ntBRou3WH
         FM9LY13qN+9XbVuXRBNrf7CDs+gkUNdlJ8iIRcKykIk6EbWJmM4elJqv83lgrCi8grbv
         oThmJnnKJj8GvZ5N+WMx1LOVj5BGly/UwDEsY=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1009131327060.26813@pobox.suse.cz>
References: <1284319955-6014-1-git-send-email-guichaz@gmail.com>
	<201009131325.01768.arnd@arndb.de>
	<alpine.LNX.2.00.1009131327060.26813@pobox.suse.cz>
Date: Mon, 13 Sep 2010 13:38:57 +0200
Message-ID: <AANLkTikQsu4qo=nkcr2N=_GLmtCgh8wmoRcZFaUJbwAs@mail.gmail.com>
Subject: Re: [PATCH] Fix hiddev's use of usb_find_interface
From: Guillaume Chazarain <guichaz@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 1:28 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> Yeah -- Guillaume, I think that you are actually seeing symptoms of
> intfdata being bogus. Could you please try with any kernel with commit
> 9c9e54a8df0be48 ("HID: hiddev: fix memory corruption due to invalid
> intfdata") applied (which is the one Arnd is talking about) and report
> back whether the problem is fixed by it?

I also saw the problem with 2.6.36-rc3. My problem is with
usb_find_interface(&hiddev_driver) not finding anything and
9c9e54a8df0be48aa359744f412377cc55c3b7d2 did not change this line.

In its current state I don't understand how hiddev_open() can possibly
work. I see people reporting suspend issues and stack traces in dmesg
but nobody reporting the driver being non-functioning, which is what
I'm doing here.

Thanks.

-- 
Guillaume
