Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0ITHUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:20:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51104 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab0ITHUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:20:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
Date: Mon, 20 Sep 2010 00:19:59 -0700
In-Reply-To: <20100917205946.GF2522@local> (Hans J. Koch's message of "Fri, 17
	Sep 2010 22:59:46 +0200")
Message-ID: <m139t451b4.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: [PATCH 0/5] uio hotplug support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement the ability to hotunplug a uio device while file handles
are still open without crashing.

I have written the code very carefully, and this survives my
basic testing.  So at the very least this is better than
what is present in uio today.

I have implemented the ``locking'' for hotunplug support in
a generic library, that should be reusable to make this
kind of support easier to add in other pieces of the kernel.

Eric W. Biederman (5):
      uio: Simplify the lifetime logic of struct uio_device.
      uio: Kill unused vma_count.
      uio: Remove unused uio_info mmap method.
      libunload: A library to help remove open files
      uio: Implement hotunplug support, using libunload

---
 drivers/uio/uio.c          |  326 ++++++++++++++++++++++++++++++--------------
 fs/Makefile                |    2 +-
 fs/libunload.c             |  166 ++++++++++++++++++++++
 include/linux/uio_driver.h |   11 +--
 include/linux/unload.h     |   33 +++++
 5 files changed, 426 insertions(+), 112 deletions(-)
