Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2AZR3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:29:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49719 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2AZR3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120126104646.GF3853@elte.hu>
References: <4f1f396019579c94fb@agluck-desktop.sc.intel.com>
	<20120126104646.GF3853@elte.hu>
Date: Thu, 26 Jan 2012 09:29:33 -0800
X-Google-Sender-Auth: Wj4qSv1RT4bl38ljT8vnua1LhKE
Message-ID: <CA+8MBbKyoM330hL830PtUz9+EVxkxVVyHcL_PbN+zYRs-BXQiw@mail.gmail.com>
Subject: Re: [GIT PULL] MCE recovery changes
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 2:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
> It worked perfectly.

Hurrah!

> Pulled, thanks!

Thank you.

> One thing i noticed was the magic constant 0x134:
>
> +               SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
>
> don't we want that defined a bit more clearly?

Stylistically it is compatible with the existing:
MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0x00c0)
and
MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x017a)

... but that's just a sign that they need some love too :-)

I'll see what I can do - but meaningful names will clearly be longer than
the hex constants that they replace - and I'm already pushing line length
limits here, so it will need more than a trivial restructure.

-Tony
