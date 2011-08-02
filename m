Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1HBQsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:48:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59899 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1HBQs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <1311281880-28041-7-git-send-email-mjg@redhat.com>
References: <1311281880-28041-1-git-send-email-mjg@redhat.com>
	<1311281880-28041-7-git-send-email-mjg@redhat.com>
Date: Tue, 2 Aug 2011 09:48:28 -0700
X-Google-Sender-Auth: 7f6_lugXXWSo76xUYxREe2lbf2s
Message-ID: <CA+8MBbJt52QxxOSJ1MHTd7Ru3Y60Bgui9PffOXcvsBed3b4_NQ@mail.gmail.com>
Subject: Re: [PATCH V2 6/9] efivars: String functions
From: Tony Luck <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mikew@google.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 1:57 PM, Matthew Garrett <mjg@redhat.com> wrote:
> +static unsigned long
> +utf16_strlen(efi_char16_t *s)
> +{
> +       return utf16_strnlen(s, ~0UL);
> +}
> +

When building with CONFIG_PSTORE=n, I see a warning:

drivers/firmware/efivars.c:161: warning: ‘utf16_strlen’ defined but not used

I can just slap:

#ifdef CONFIG_PSTORE
...
#endif

around this function definition - but I wondered if there was a better way
to fix it?

-Tony

Also with CONFIG_PSTORE=n I see:
drivers/firmware/efivars.c:602: warning: initialization from
incompatible pointer type
but that one just needs the stub definition of "efi_pstore_write" to
match the real
definition with "part" being unsigned.
