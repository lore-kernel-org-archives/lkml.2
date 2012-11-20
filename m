Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2KTUI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:08:28 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50985 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2KTUI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:08:27 -0500
MIME-Version: 1.0
Date: Tue, 20 Nov 2012 12:08:26 -0800
X-Google-Sender-Auth: pKhjIkxuegiB93zOK1TIsdR5x-k
Message-ID: <CAGXu5j+g8inUZV43GFQzs9KpRvjPGPTJsXinb4Y=wOuOf2jnVQ@mail.gmail.com>
Subject: opp_get_notifier() needs to be under rcu_lock?
From: Kees Cook <keescook@chromium.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like find_device_opp() (called from opp_get_notifier()) needs
to be under RCU read lock, but this doesn't seem to be happening in
drivers/devfreq/devfreq.c. Doesn't this run the risk of referencing a
freed variable?

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
