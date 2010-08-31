Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0HaOEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:04:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46758 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab0HaOEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k6lrcfjcgc2SLfi8f3UuJgPXQcNhkpr6wDrM+jwg5OzZf8WunONPZBKGL9EmFU+Ifx
         hYmdKzSbPQVMLEo30gis3x+b8YFZVgOUz0+7VjNt31Hobx6g92lIAjIcxtfmlqfc6TPj
         WxL5BdMTwNVFHZshSJg70HsirJAcrc8J8lYts=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1008310951090.1538-100000@iolanthe.rowland.org>
References: <4C7CA411.5070601@ladisch.de>
	<Pine.LNX.4.44L0.1008310951090.1538-100000@iolanthe.rowland.org>
Date: Tue, 31 Aug 2010 22:04:47 +0800
Message-ID: <AANLkTimCYmyfrvP2-k=cfFbxayP8XWpNZKonRJjNvs6q@mail.gmail.com>
Subject: Re: [PATCH] USB: output an error message when the pipe type doesn't
 match the endpoint type
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Clemens Ladisch <clemens@ladisch.de>, Simon Arlott <simon@fire.lp0.eu>,
        Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 9:52 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 31 Aug 2010, Clemens Ladisch wrote:
>
>> Simon Arlott wrote:
>> > Commit f661c6f8c67bd55e93348f160d590ff9edf08904 adds a check of the pipe type if
>> > CONFIG_USB_DEBUG is enabled,
>>
>> I didn't see that commit last year, but wouldn't it break devices like
>> the ESI MIDI Mate whose descriptors want to have low-speed bulk transfers
>> and where the driver has to submit interrupt transfers instead to get it
>> to work at all?
>
> When the kernel sees those invalid low-speed bulk endpoint descriptors,
> it changes its internal copy of the descriptor to interrupt.  Hence
> when the driver submits interrupt URBs, they work correctly.
>

Interesting.

FYI: even though XP/Win2k allow low-speed bulk endpoints, Vista
and Win7 do not allow that.

There are hacks to get around that.
http://www.recursion.jp/avrcdc/lowbulk.html

I took a look at the libusb-win32 source and indeed the author
is using the same trick of submit interrupt URBs.


-- 
Xiaofan
