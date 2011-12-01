Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1LAXpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:45:44 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62938 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab1LAXpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:45:43 -0500
Date: Fri, 2 Dec 2011 00:45:25 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@ozlabs.org
Cc: siglesia@cern.ch, manohar.vanga@cern.ch, dave.martin@linaro.org
Subject: [RFC PATCH V2 0/1] making order in file2alias
Message-ID: <cover.1322781825.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this message is the RFC, the patch itself is expected to be fine)

This is a repost of what I've sent on Nov 4th.  Since Rusty asked to
only do the first step, here it is.  I rebased on next-20111201 and it
still works fine.

As for the previous 2/2 (see https://lkml.org/lkml/2011/11/4/127 ),
I still think it makes sense. And as Dave Martin suggested, we can
do without the array.

Thus, I may prepare three smaller steps, if that's acceptable (greg?)

  step 1: create the ELF section so ENTRY() lines can leave the array
          (and change name accordingly).

  step 2: each ENTRY() line can be moved just after the associated code
          (this means that a new bus is just a single hunk, not 2 of them)

  step 3: I create the headers needed to move code and ENTRY in separate
          files. This is some movement around, not trivial so it may
          deserve a patch in itself.

  step 4 and later ones: Individual busses may reach their own external file,
         conditionally compiled per Kconfig rules.

If that's something worth evaluating, I can do that over the weekend.

thanks
/alessandro

Alessandro Rubini (1):
  modpost: use table-lookup to build module aliases

 scripts/mod/file2alias.c |  166 +++++++++++++++++-----------------------------
 1 files changed, 60 insertions(+), 106 deletions(-)

-- 
1.7.7.2
