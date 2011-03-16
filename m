Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab1CPEZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:25:25 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:48548 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943Ab1CPEY4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:24:56 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 00:24:56 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3FLz5kEqlFTIVphgkZPPjL64hnJIodkrGPYyB9fLuAWsIMbiANIB/A6TbP43rqdPoixRvdGlQbnLsTKpdj80tT00UGwItuoldkxfjwb6MTooWn//2PAch4+ZsW8QhA+bWVHqgtD6Q/o9EUMQMPEexYiCFlRA+T2aFzhVB93lRKc=;
Message-ID: <403815.22502.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: u2lamPUVM1m2Fdsj8Patfdct0og3kKzIBh1_c17c58WcXWX
 oreUeVr8L2rSRFSZCea4CK8DtfnUxjonQAA5GhiUn4WiUT2VxtEhIoIi0T8D
 Yg5Q8jrOjbbLUu6j75RfNKAImP2WS7Ao24ngp3yfHRBvY23_cMAI5xF7JBH_
 aTHFuPbt.2v7tdSHkEbVUbkZsW8QkBmPE5R2WzjMUnNBF9H0pDiFXxrjYjql
 Q_F2_yeHowdTPaNsYTXgIe62blXZv1F8dWTHFNK5QWUXaLHuc6xegrCTA9wD
 MOjdUKebzH_83bk74CoxRGY_KbmZjvB7SGS58OgeoQANWQDXNXVLNW5L12c9
 .DhrX
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Tue, 15 Mar 2011 21:18:14 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
To: akpm@linux-foundation.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: maximlevitsky@gmail.com, fujita.tomonori@lab.ntt.co.jp,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110316113527C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I don't think so.
> 
> Splitting (or merging) a request and playing with sg lists
> inside a
> driver is a bad idea. Such should be done in the block
> layer.
> 
> I still don't see why the block layer can't do that for the
> driver.
> 
> I believe that the helper functions for such should not be
> added.
> 


In a particular case of flash-like devices, letting the block layer
split requests into memory sequential blocks too often results in
unnecessary fragmentation of writes/erases.

If only one sg entry is requested from the block layer, it will be (more
often than not) only 1 or 2 pages in length, even if total size of
prospective write request spans multiple erase blocks.

So there are really only two options for legacy memorystick driver:
1. Play with scatterlists explicitly.
2. Make it an MTD backend, rather then stand-alone block device.

The second option makes more sense, but it is not necessarily the optimal
approach for implementation of this particular media format.



      
