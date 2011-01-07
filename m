Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1AGDVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:21:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45203 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab1AGDVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:21:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=G9Wzoh5HtMqn5A5bQzafGUF21MgKvZZpgzMq6xIaMk3SWizEpxF+607V3ewgsBtIWq
         wYWeMsyXEe+MD6mP2Ve4UZnw7HLowpgDHa1HaHLtU8G4eW+QNuUFp0C6foXiybngneoD
         PX0XyOcPFQka9go2Guya5jS2XecBtRFeXNbys=
MIME-Version: 1.0
Date: Thu, 6 Jan 2011 22:21:29 -0500
Message-ID: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
Subject: Who does determine the number of requests that can be serving
 simultaneously in a storage?
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, cmm@us.ibm.com, rwheeler@redhat.com, vgoyal@redhat.com,
        czoccolo@gmail.com, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We know that couples of requests can be serving simultaneously in a
storage because of NCQ. My question is that who does determine the
exact number of the servicing requests in HDD or SSD? Since the
capability for different storages(hdd/ssd) to server multiple requests
is different, how the OS know the exact number of requests that can be
served simultaneously?

I fail to figure out the answer. I know the dispatch routine in I/O
schedulers is elevator_dispatch_fn, which are invoked at two places.
One is in __elv_next_request(), the other is elv_drain_elevator(). I
fail to figure out the exact condition to trigger the routine of
elv_drain_elevator(), from the source code, I know that it should
dispatch all the requests in pending queue to "request_queue", from
which the request is selected to dispatch into device driver.

For __elv_next_request(), it is actually invoked by
blk_peek_reqeust(), which is invoked by blk_fetch_request(). From
their comments, I know that only a request should be fetched from
"request_queue" and this request should be dispatched into
corresponding device driver. However, I notice that blk_fetch_request
is invoked at a number of places, it fetches the requests endlessly
with different stop condition. Which condition is the exact one that
control the number of requests which can be served at the same time?
The OS would of course not dispatch requests more than that the
storage can serve, for example, for SSD, the number of multi requests
serving simultaneously might be 32, while for HDD, the number is 4.
But how the OS handle this?

Does different file system handle this differently?

I appreciate any help. Thanks very much!

Yuehai
