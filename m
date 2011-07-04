Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1GDFfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:35:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58954 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1GDFfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110703171626.GG21127@elf.ucw.cz>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
	<1309702581-16863-4-git-send-email-akinobu.mita@gmail.com>
	<20110703171626.GG21127@elf.ucw.cz>
Date: Mon, 4 Jul 2011 14:35:04 +0900
Message-ID: <CAC5umyhKafTgUe6T2vfLupwmBwt5COj6X2nUH2b5ekhzQNi5mg@mail.gmail.com>
Subject: Re: [PATCH 3/7] fault-injection: notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-pm@lists.linux-foundation.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/4 Pavel Machek <pavel@ucw.cz>:
>
>> +     for (action = enb->actions; action->name; action++) {
>> +             struct dentry *file = debugfs_create_int(action->name, mode,
>> +                                             enb->dir, &action->error);
>> +
>> +             if (!file) {
>> +                     debugfs_remove_recursive(enb->dir);
>> +                     return -ENOMEM;
>> +             }
>
> Few lines how this work would be welcome...?

OK, I'll add a comment like below.

/*
 * Create debugfs r/w file containing action->error. If notifier call
 * chain is called with action->val, it will fail with the error code
 */
