Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab2KNRMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:12:03 -0500
Received: from mail2.ruggedcom.com ([204.50.148.11]:48191 "EHLO
	mail2.ruggedcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab2KNRMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:12:02 -0500
Message-ID: <50A3D0E1.4060209@ruggedcom.com>
Date: Wed, 14 Nov 2012 12:12:01 -0500
From: Richard Retanubun <richardretanubun@ruggedcom.com>
Organization: Ruggedcom
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>
Subject: Re: kmemleak report on isp1763 and sierra MC8705
References: <Pine.LNX.4.44L0.1210291806360.31151-100000@netrider.rowland.org> <509D804A.7080807@ruggedcom.com> <CAMgPeKUPeJSKas2VOqbG+Nt5MOtdA3jUUCsFwUcDVhwDJJCr6A@mail.gmail.com>
In-Reply-To: <CAMgPeKUPeJSKas2VOqbG+Nt5MOtdA3jUUCsFwUcDVhwDJJCr6A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/12 09:30 AM, Johan Hovold wrote:
Hi Johan,

> There was a reference-count fix for the probe error path that went in to
> v3.5. Haven't read all the details on how you trigger your leak, but at
> the face of it, it could be related.
>
> Have a look at 0658a3366db7e27fa ("usb: use usb_serial_put in
> usb_serial_probe errors). If related, you should be seeing "Ignoring
> blacklisted interface #n" messages when you enable debug (e.g. #define
> DEBUG) in the sierra driver.

That was it! Thanks so much for the research.
I can apply it cleanly to 3.0.22 and see usb_release_dev() being called and thus no more kmemleak.

>
> Greg, it seems to me that the fix referred to above should be backported
> to the earlier stable trees either way.
I would vote "yes" for this also.

While my setup circumstances may be a corner case, (modem kept resetting to re-establish PPP connection)
it was leaking 1192 bytes per occurrence.

Thanks for everyone's time.

-- Richard Retanubun.
