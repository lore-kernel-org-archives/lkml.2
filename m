Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1FITrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:47:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56262 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab1FITra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=IGqi5yK5cKWt1/qw/9l+7wOPltGmntUnsIQLJ2WCvDNfbzTlKbKI77wiS4o3t2U7cv
         bDNY/qW7n5UZfvAUShJzNdx5LWgCgjyFbQrp7AtAhbozX39dIb2NdFW79HqI35MzW94n
         6G7Hu5X8GSfWzWv5IE1sPcNE7BGRmDifulmwU=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=LZ=rGMOJopOeZ5zmmxcFEDDbDiw@mail.gmail.com>
References: <BANLkTi=LZ=rGMOJopOeZ5zmmxcFEDDbDiw@mail.gmail.com>
Date: Thu, 9 Jun 2011 15:47:29 -0400
Message-ID: <BANLkTikMLvgtAJp8Vex2u-Fcv5YGMvWBgg@mail.gmail.com>
Subject: Consensus inquiry regarding POSIX_FADV_NOREUSE
From: "Jonah H. Harris" <jonah.harris@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm thinking about implementing the POSIX_FADV_NOREUSE advice option
of fadvise (mm/fadvise.c). While POSIX_FADV_DONTNEED works for many
use cases, it would be nice to forcibly evict pages as quickly as
possible to avoid having a single application pollute the cache --
especially when cache is used more heavily by other applications.

I have some ideas in regard to implementation, but as of yet I don't
have a concrete proposal. Instead, I wanted to see whether anyone is
averse to the idea before I start researching it more completely. To
that end, I've reviewed a large number of previous discussions and am
seeking clarification in regard to the current consensus of the
following:

  For developers who don't want their pages cached, should they use
O_DIRECT or fadvise?

In the past, I've used O_DIRECT quite successfully. But as it requires
dealing with alignment, it's not as simple to use or as general-case
as fadvise.

Thoughts?

--
Jonah H. Harris, VP of Architecture
myYearbook.com
