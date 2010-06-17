Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213Ab0FQOzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:55:04 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19129 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0FQOzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:55:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=pwdMg3+BCHxXnXW/yHN2Pd56SdokKSvt/85UXXNeVzxnFbIpoehcJtmFZEA4UbsR5
	DcstSO1GFTIb/JKsaVrCw==
MIME-Version: 1.0
Date: Thu, 17 Jun 2010 16:54:57 +0200
Message-ID: <AANLkTinB-0TzyRnjvOwWFetub1-4lhqxXFxYwsOhL3Kl@mail.gmail.com>
Subject: [BUG] perf: installed python -report scripts have bogus paths
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was looking at the perf trace and python scripting support.
But I quickly ran into an issue. I compiled with:
$ make prefix=/usr
$ make prefix=/usr install

All the scripts are installed in /usr/libexec/perf-core/scripts/.....

The problem is that all the -report scripts have the .py script
paths hardcoded as ~/libexec/.....

Here is an example with syscall-counts-report
perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts.py $comm

That should either be stripped to syscall-counts.py and perf trace adds the
prefix or make install needs to patch the path in. Otherwise I don't see how
this can work unless I am confused about the usage model.
