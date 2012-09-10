Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab2IJM2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:28:45 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:17985 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2IJM2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:28:43 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=ze8vXcLd6HouI0WqxmsfD/ef6Xv6zvm880s5UG4dANTFGz3/rKMtukR9pmxF
	RzpVBZAGIIJV6zAJYVrOpuA+ckwmhOg46xiLiqriROOX1QYcWlxb4i+t7
	LKhzIBcJ/SCWlKqz5QpGCCt5qIMdJ8O2FPoNo/QQ8WDIMYZymx0yug=;
X-Spam-Processed: mail.digidescorp.com, Mon, 10 Sep 2012 07:28:31 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1600b59183=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1347280111.2101.8.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, bfields@fieldses.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 10 Sep 2012 07:28:31 -0500
In-Reply-To: <87oblfpmnb.fsf@devron.myhome.or.jp>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	 <20120904161747.GJ23464@ZenIV.linux.org.uk>
	 <CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	 <87harc34d9.fsf@devron.myhome.or.jp>
	 <CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	 <87y5knz6l5.fsf@devron.myhome.or.jp>
	 <CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
	 <CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
	 <1347020137.2223.13.camel@iscandar.digidescorp.com>
	 <87oblfpmnb.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-09 at 18:32 +0900, OGAWA Hirofumi wrote:

> What is your use case?  

What Neil Brown refers to as a "general file access protocol" -
basically making a flash disk available to a small embedded network for
random-access file I/O.

The flash disk is required to interoperate with Windoze, which forces us
into VFAT-backed NFS.

> I'm assuming current NFS support of FAT is still unstable behavior even with your 
> patches. Is this true?

We use lookupcache=none, which I thought had stabilized things. Based on
what Namjae has found with ESTALE on rename/drop_caches I guess there is
a hole.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


