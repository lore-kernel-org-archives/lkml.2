Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BOSdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:33:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab2BOSdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:33:22 -0500
Date: Wed, 15 Feb 2012 13:33:18 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: exit_mmap() BUG_ON triggering since 3.1
Message-ID: <20120215183317.GA26977@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had three reports against the Fedora kernel recently where
a process exits, and we're tripping up the 

        BUG_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);

in exit_mmap()

It started happening with 3.1, but still occurs on 3.2
(no 3.3rc reports yet, but it's not getting much testing).

https://bugzilla.redhat.com/show_bug.cgi?id=786632
https://bugzilla.redhat.com/show_bug.cgi?id=787527
https://bugzilla.redhat.com/show_bug.cgi?id=790546

I don't see anything special in common between the loaded modules.

anyone?

	Dave
