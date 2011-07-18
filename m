Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab1GRU6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:58:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39067 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1GRU63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <1311021033-7483-5-git-send-email-mjg@redhat.com>
References: <1311021033-7483-1-git-send-email-mjg@redhat.com>
	<1311021033-7483-5-git-send-email-mjg@redhat.com>
Date: Mon, 18 Jul 2011 13:58:28 -0700
X-Google-Sender-Auth: -pfJNrTTnD8HxM5smtPXgxKBZb4
Message-ID: <CA+8MBbJMHK1e_wGC9EE+8neVc2j9Y8Ut4vzPiGh2umNZENsK1Q@mail.gmail.com>
Subject: Re: [PATCH 4/9] pstore: Allow the user to explicitly choose a backend
From: Tony Luck <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mikew@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 1:30 PM, Matthew Garrett <mjg@redhat.com> wrote:.
> +
> +               Pstore only supports one backend at a time. If multiple
> +               backends are available, the preferred backend may be
> +               set by passing the pstore.backend= argument to the kernel
> +               or writing to /sys/module/pstore/parameters/backend .
> \ No newline at end of file

Maybe we should have a newline :-)

We don't allow backends to be unregistered (currently) - Do you think it would
be helpful to mention in this text that you cannot change your mind and
switch to a different back end once you have registered one? Writing
to /sys/module/... sounds a lot more flexible than what reality will allow.


> +       if (backend && strcmp(backend, psi->name)) {
> +               spin_unlock(&pstore_lock);
> +               return -EBUSY;
> +       }

EBUSY doesn't feel like the right error here (and we are using that
to indicate that some other backend is already registered).  Not
sure what is the right one though. ENOENT? EINVAL?

-Tony
