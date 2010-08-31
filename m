Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0HaLbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:31:39 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:43691 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab0HaLbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:31:38 -0400
Message-ID: <8667814b4151f2e31b15095380c41b07ebbd3cc0@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <4C7CA411.5070601@ladisch.de>
References: <4C7C279C.507@simon.arlott.org.uk>
    <4C7CA411.5070601@ladisch.de>
Date: Tue, 31 Aug 2010 12:31:34 +0100
Subject: Re: [PATCH] USB: output an error message when the pipe type 
 doesn't match the endpoint type
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Clemens Ladisch" <clemens@ladisch.de>
Cc: "Greg KH" <greg@kroah.com>, "Alan Stern" <stern@rowland.harvard.edu>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "USB list" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, August 31, 2010 07:41, Clemens Ladisch wrote:
> Simon Arlott wrote:
>> Commit f661c6f8c67bd55e93348f160d590ff9edf08904 adds a check of the pipe type if
>> CONFIG_USB_DEBUG is enabled,
>
> I didn't see that commit last year, but wouldn't it break devices like
> the ESI MIDI Mate whose descriptors want to have low-speed bulk transfers
> and where the driver has to submit interrupt transfers instead to get it
> to work at all?

If the transfer type doesn't match the pipe type then yes, but only when
CONFIG_USB_DEBUG is enabled.

Perhaps these need to be moved to a CONFIG_USB_STRICT. Having a "debug" mode
change the behaviour is not a good idea, but some of the code in that ifdef
has been there since the import to git.

Regardless of which configuration option enables it, the pipe type
check needs an error message to explain why the driver received -EPIPE.

-- 
Simon Arlott
