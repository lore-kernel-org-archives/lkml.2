Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3AHW52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:57:28 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:36866 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3AHW51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:57:27 -0500
MIME-Version: 1.0
In-Reply-To: <20121221163455.GG15204@liondog.tnic>
References: <20121221163455.GG15204@liondog.tnic>
Date: Tue, 8 Jan 2013 14:57:26 -0800
X-Google-Sender-Auth: LUbpHqHbaLulfCXG-lzPnASKAFQ
Message-ID: <CA+8MBb+yxuLtJhAzOWqcEtmhbF11iXXJymQ8Wyxq3CSJ-nfuLA@mail.gmail.com>
Subject: Re: x86, MCE: Retract most UAPI exports
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 8:34 AM, Borislav Petkov <bp@alien8.de> wrote:
> Hi Tony,
>
> we talked about this already and now that -rc1 is imminent, here's what
> I'm thinking of hiding back from UAPI so that there are no conflicts
> with userspace. I've left structs mce and mce_log since I know they're
> used in mcelog. Please take a look and let me know if I'm being too
> overzealous. I'd like to send this out for 3.8 still so that no exports
> get cast in stone.

I think we should also pull "struct mce_log" definition back too. It's
purely an internal structure. "struct mce" is the only bit that is user
space visible via /dev/mcelog.

I.e. the uapi version should only contain the "struct mce" definition
and the three ioctl codes.

-Tony
