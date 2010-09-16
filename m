Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0IPGvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:51:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48628 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0IPGvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:51:44 -0400
MIME-Version: 1.0
In-Reply-To: <1284589207.4672.3.camel@maxim-laptop>
References: <1284284969.2928.18.camel@maxim-laptop> <1284427621.4127.7.camel@maxim-laptop>
 <4C8F2699.3020509@kernel.org> <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
 <1284507516.4963.2.camel@maxim-laptop> <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
 <1284511071.3551.1.camel@maxim-laptop> <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
 <20100915132731.GA20558@khazad-dum.debian.net> <AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>
 <1284589207.4672.3.camel@maxim-laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 16 Sep 2010 08:51:28 +0200
Message-ID: <AANLkTin37rbEbcGDejhcsnxZNYhhUWGy+x=v4Y=s0_Qx@mail.gmail.com>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 00:20, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> So it makes the sense.
> It turns out that hal is still running on ubuntu systems, and yes, it
> still polls the drives, and yes I disabled that feature....
> So restoring that polling feature indeed fixes that problem for now.
> Yet, why without that commit detection did work?

Really, I have no idea how this can happen. You could only find out
with blocktrace, if something else is trying to open the device. The
state change in the drive should not be able to get known to the host
unless something is causing i/o with open().

Kay
