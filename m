Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0ION1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:27:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35265 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab0ION1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:27:35 -0400
X-Sasl-enc: 0nCC1/HCgHEEEV69QSBhQ7NWImrqscyZaE8iOV0F8Fdg 1284557254
Date: Wed, 15 Sep 2010 10:27:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
Message-ID: <20100915132731.GA20558@khazad-dum.debian.net>
References: <1284284969.2928.18.camel@maxim-laptop>
 <1284427621.4127.7.camel@maxim-laptop>
 <4C8F2699.3020509@kernel.org>
 <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
 <1284507516.4963.2.camel@maxim-laptop>
 <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
 <1284511071.3551.1.camel@maxim-laptop>
 <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010, Kay Sievers wrote:
> It's only the polling that should be able to trigger these events for
> the device. the device itself can't report any changes to the host,
> unless you have a SATA drive which can send AN (async notification)
> events. But we disabled the AN support recently, because it was
> running in loops on some boxes.

Is it so widespread or extremely difficult to detect, that it justifies
breaking AN for all users?

Anyway, if userspace thinks AN is available, it won't pool or touch
/dev/sr*, which would explain the problem (but one still would have to find
the root cause: why userspace thinks it doesn't need to pool?).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
