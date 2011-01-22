Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1AVOsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:48:06 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47273 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1AVOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:48:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=f0YxWVfg2sVRZ7BSLtR8j8FmaE7Bqc06c7pR5UNuZR04YH0XvxnRz12m4S91J1Bt8p
         oNY/TlQ0zqIqqvJin+Ae+pSXi+ugSX3J9XnXYgajPuObMlrGZxZqO+JlRy4unhhSYRIT
         YMKsiHARUYfGs1ETfLJDfBwAm1BsFv7aLfAzs=
MIME-Version: 1.0
Date: Sat, 22 Jan 2011 15:48:03 +0100
Message-ID: <AANLkTikdwZp1r_MD4TH7bsLjzPAtHzq7XWoLZmFwdK=S@mail.gmail.com>
Subject: COMPACTION and TRANSPARENT_HUGEPAGE config warning
From: Luca Tettamanti <kronos.it@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrea,
this commit:

commit 5d6892407cab23d4bf2f6de065ca351a53849323
Author: Andrea Arcangeli <aarcange@redhat.com>
Date:   Thu Jan 13 15:47:07 2011 -0800

    thp: select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE enabled

causes this warning during the configuration process:

warning: (TRANSPARENT_HUGEPAGE) selects COMPACTION which has unmet
direct dependencies (EXPERIMENTAL && HUGETLB_PAGE && MMU)

This happens because 'select' does not enable the dependencies of its
target, so when I selected THP it also enabled COMPATION but I don't
have HUGETLBFS (=HUGETLB_PAGE) enabled.
Making THP select HUGETLB_PAGE fixes the warning but I'm not 100% sure
that's correct (does it work without HUGETLBFS?).

Luca
