Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2FJOG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:06:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2FJOG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:06:26 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206080938400.1360-100000@iolanthe.rowland.org>
References: <1339133929-30679-1-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1206080938400.1360-100000@iolanthe.rowland.org>
Date: Sun, 10 Jun 2012 22:06:23 +0800
Message-ID: <CACVXFVOh2ex7-p_qqPDN5XyTQFaAhEXczPdCqJfNihb0N9GBdw@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v1)
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 9:40 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Would you prefer to use device_trylock in a loop?  I guess this comes

Yes, looks trylock in loop is safer than locking simply, and another
advantage is that the buggy device or driver can be logged.

So will do the v2 using trylock.

> down to which you prefer: a hang during shutdown, or a crash.  :-)

Considered that the device or driver can be logged, either hang or
crash will be fixed later by someone, :-)

Thanks,
--
Ming Lei
