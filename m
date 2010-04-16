Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab0DPPp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:45:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58326 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab0DPPp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=qgTgiyUAZEpYlLg3Sr3sAkPcAB09FkCOQXU+6A5yXkjZCI12GbD3yAUin10M6nrkBp
         IpEMBIvIRLWtrZB0G82ykhqlnuTcEKVUN46CHGc7gQeuJH5HGYhKavFsfS4XK2Ctp7BH
         /bG8yZqvV/LWP+JOB6NTgHEU+fwMyDtu3cqOY=
Subject: Process-shared futexes on hugepages puts the kernel in an infinite
 loop in 2.6.32.11; is this fixed now?
From: r6144 <rainy6144@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="GB2312"
Date: Fri, 16 Apr 2010 23:45:22 +0800
Message-ID: <1271432722.2564.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm having an annoying kernel bug regarding huge pages in Fedora 12:

https://bugzilla.redhat.com/show_bug.cgi?id=552257

Basically I want to use huge pages in a multithreaded number crunching
program, which happens to use process-shared semaphores (because fftw
does it).  The futex for the semaphore ends up lying on a huge page, and
I then get an endless loop in get_futex_key(), apparently because the
anonymous huge page containing the futex does not have a page->mapping.
A test case is provided in the above link.

I reported the bug to Fedora bugzilla months ago, but haven't received
any feedback yet.  The Fedora kernel is based on 2.6.32.11, and a
cursory glance at the 2.6.34-rc3 source does not yield any relevant
change.

So, could anyone tell me if the current mainline kernel might act better
in this respect, before I get around to compiling it?

Thank you very much.

Please CC me as I'm not subscribed.

r6144

