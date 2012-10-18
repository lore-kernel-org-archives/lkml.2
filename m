Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2JRIim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:38:42 -0400
Received: from mx0.aculab.com ([213.249.233.131]:39709 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751748Ab2JRIik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:38:40 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] SUNRPC: Prevent kernel stack corruption on long values of flush
Date: Thu, 18 Oct 2012 09:34:57 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7050@saturn3.aculab.com>
In-Reply-To: <507EF918.5030004@panasas.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH] SUNRPC: Prevent kernel stack corruption on long values of flush
thread-index: Ac2slXufUa73+C1xTru4BcF0apTYOwAdQ0tQ
References: <1342476086-21638-1-git-send-email-levinsasha928@gmail.com> <20120718173913.GA1298@fieldses.org> <20120718200049.GA17964@umich.edu> <20120718203304.GA18540@redhat.com> <20120718205510.GA18374@umich.edu> <507EF918.5030004@panasas.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Boaz Harrosh" <bharrosh@panasas.com>, "Jim Rees" <rees@umich.edu>
Cc: "Dave Jones" <davej@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>,
        "Sasha Levin" <levinsasha928@gmail.com>, <Trond.Myklebust@netapp.com>,
        <davem@davemloft.net>, <linux-nfs@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9I8cnN8009350

> ...
> long is always the same or bigger then a pointer
> (A pointer must always fit in a long)
> ...

Linux may make that assumption, but it doesn't have
to be true. 64bit windows still has 32bit long.
C99 inttypes.h defines [u]intptr_t to be an integral type
that is large enough to hold a pointer to any data item.
(That in itself is problematic for implementations that
encode multiple characters into a machine word and need
to use 'fat' pointers in order to encode the offset.)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
