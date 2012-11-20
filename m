Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2KTRmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:42:45 -0500
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:32862 "EHLO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab2KTRmo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:42:44 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 305692.73846.bm@omp1015.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rCUoKMh4wVBP9/Pz34PBRnhJ7jNcqGv418zZn/zwzuFJo96DNZLEps99CRcBJ1r3VgYfYO/BCmzT9hmILt591pDACB+S4vbfnXQ7K6qx1x8CE6EujRSfkzF/3J4M/NCWmIA3PUICzzAnypPd4E/XAEFeqDLvRH26UVAYdwlouxw=;
X-YMail-OSG: dJmwW9wVM1klPBRv_2GT5R0YtFUYEotYPQ1l2rJ4wEXqxq5
 TXPHtaas7SluZiEGNGcbQCw49S.8oei5EyWjDedOzPOk0VavK3iw4lgiEEFT
 3kG8vwr1C5nV7x5rAklyhQ7nrStF3pLFOSTs6Q5UXbZ4V._nwgln7Kmm.gH2
 BtEC7X1PthJjsQG2aKSIwxv24j6qew4p5R_ou0MQzFq6VzJVRDetU6PiMvxc
 7Mnw6PPJDTB.OsxwGCLi443Ovsni6NLcKGoLIYNvKjgvy_6QxT3a4eyNsk7g
 bUMnTZxyyXQgQ6KS8bwCjL2S9_y97aJjelJTcMepkHseC9uOGhAaV00POb.A
 .H8Aj9zNWwVVTV8iDNBiVx0sTg8wMVF8Clq9MqLOJzBxNEWxQQHjrZIAaK4S
 8FQvXLQBEi.iMSyUMfbtlOTciR1sJ7cHB3bIiT90Z7C4lX6QGdZ8c5jza.su
 vl221AvPUCTkQMhr9nDH6QlimK3z0TKRxyaYQXOkWBS2HQmpFSvUA
X-Rocket-MIMEInfo: 001.001,SSBoYXZlIHR3byBQb3N0Z3JlU1FMIGRhdGFiYXNlcyBuYW1lZCBkYXRhLTEgYW5kIGRhdGEtMiB0aGF0IHNpdCBvbiB0aGUgc2FtZSBtYWNoaW5lLiBCb3RoIGRhdGFiYXNlcyBrZWVwIDQwIEdCIG9mIGRhdGEsIGFuZCB0aGUgdG90YWwgbWVtb3J5IGF2YWlsYWJsZSBvbiB0aGUgbWFjaGluZSBpcyA2OEdCLgoKSSBzdGFydGVkIGRhdGEtMSBhbmQgZGF0YS0yLCBhbmQgcmFuIHNldmVyYWwgcXVlcmllcyB0byBnbyBvdmVyIGFsbCB0aGVpciBkYXRhLiBUaGVuLCBJIHNodXQgZG93biBkYXRhLTEgYW5kIGtlcHQBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.126.470
Message-ID: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com>
Date: Tue, 20 Nov 2012 09:42:42 -0800 (PST)
From: metin d <metdos@yahoo.com>
Reply-To: metin d <metdos@yahoo.com>
Subject: Problem in Page Cache Replacement
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two PostgreSQL databases named data-1 and data-2 that sit on the same machine. Both databases keep 40 GB of data, and the total memory available on the machine is 68GB.

I started data-1 and data-2, and ran several queries to go over all their data. Then, I shut down data-1 and kept issuing queries against data-2. For some reason, the OS still holds on to large parts of data-1's pages in its page cache, and reserves about 35 GB of RAM to data-2's files. As a result, my queries on data-2 keep hitting disk.

I'm checking page cache usage with fincore. When I run a table scan query against data-2, I see that data-2's pages get evicted and put back into the cache in a round-robin manner. Nothing happens to data-1's pages, although they haven't been touched for days.

Does anybody know why data-1's pages aren't evicted from the page cache? I'm open to all kind of suggestions you think it might relate to problem.

This is an EC2 m2.4xlarge instance on Amazon with 68 GB of RAM and no swap space. The kernel version is:

$ uname -r
3.2.28-45.62.amzn1.x86_64
Edit:

and it seems that I use one NUMA instance, if  you think that it can a problem.

$ numactl --hardware
available: 1 nodes (0)
node 0 cpus: 0 1 2 3 4 5 6 7
node 0 size: 70007 MB
node 0 free: 360 MB
node distances:
node   0
  0:  10
