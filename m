Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319Ab2GMRsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:48:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50385 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2GMRsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120713173536.GB25432@redhat.com>
References: <20120713173536.GB25432@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 10:47:43 -0700
X-Google-Sender-Auth: BkRrhkzIAupE83OvnXR7p5tS9qk
Message-ID: <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
Subject: Re: Remove easily user-triggerable BUG from generic_setlease
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:35 AM, Dave Jones <davej@redhat.com> wrote:
> This can be trivially triggered from userspace by passing in something unexpected.

Argh. It looks like it would be harmless (apart from the noise),
except we hold file_lock_lock. Which turns the BUG_ON() into not just
"noise and kill the process", but "noise and kill the process and
leave a nasty lock held".

This seems to go back to 3.2, so stable should be cc'd, no?

               Linus
