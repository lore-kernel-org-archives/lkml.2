Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2J3QpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:45:22 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59695 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704Ab2J3QpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <1351608026-12208-1-git-send-email-colin.king@canonical.com>
References: <1351608026-12208-1-git-send-email-colin.king@canonical.com>
Date: Tue, 30 Oct 2012 09:45:20 -0700
X-Google-Sender-Auth: BIXhYssyz4uiQ10UtKqxbIZqq7Y
Message-ID: <CAGXu5j+YbQ0xBEVtn1ZNAPg=2vY90Yd4wEOwPatMTWC40zVkKg@mail.gmail.com>
Subject: Re: [PATCH] pstore: fix NULL pointer dereference in console writes
From: Kees Cook <keescook@chromium.org>
To: Colin King <colin.king@canonical.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 7:40 AM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Passing a NULL id causes a NULL pointer deference in writers
> such as erst_writer and efi_pstore_write because they expect
> to update this id.  Pass a dummy id instead.
>
> This avoids a cascade of oopses caused when the initial
> pstore_console_write passes a null which in turn causes
> writes to the console causing further oopses in subsequent
> pstore_console_write calls.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Good catch; thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
