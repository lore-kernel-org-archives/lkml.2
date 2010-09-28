Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0I1QQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:16:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39292 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0I1QQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:16:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nQeEpEqt8cPvsEBiFsjLrRJpR1DZwFiiVnh7FvO+RAvypKEeyQ8YoBuBZ5DassAkPp
         FrV2LlSJZAqpedICYwMLQQ06dkRbQVzmfqj29b/BZxZJLbE/MqWLD21js97nJdA2fC9x
         NtsKA8kQL9fdQ9yiI3VnuBFU8s+xUYNgWBrwA=
MIME-Version: 1.0
Date: Tue, 28 Sep 2010 18:16:19 +0200
Message-ID: <AANLkTi=PTp7YW_eYxtF-H2QSxgei3whWH59wU0C9oCkz@mail.gmail.com>
Subject: [REGRESSION] um: ubd: block layer issue (Was: ext3 filesystem
 corruption in user mode linux)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: tj@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, axboe@kernel.dk,
        jdike@addtoit.com, Geert.Uytterhoeven@sonycom.com,
        grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
        mike.miller@hp.com, Chris Frey <cdfrey@foursquare.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun!

Chris Frey ran into some problems with ext3 on UML.
See: http://marc.info/?i=20100924041410.GA18040%20()%20foursquare%20!%20net

I can reproduce this issue with any file system on Linux >= 2.6.31.
There seems to be a serious problem with the block layer on UML.
Under high load any file system gets corrupted.

The regression was most likely introduced with this three changes:
83096ebf1263b2c1ee5e653ba37d993d02e3eb7b (block: convert to pos and
nr_sectors accessors)
f81f2f7c9fee307e371f37424577d46f9eaf8692 (ubd: drop unnecessary
rq->sector manipulation)
4d6c84d91d1a539ebc47d1a36a35e9390ba11fdc (ubd: cleanup completion path)

Maybe only f81f2f7 is the bad one. They depend on each and I don't
know all the internals...

-- 
Cheers,
//richard
