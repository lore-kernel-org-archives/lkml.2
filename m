Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2GRR1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:27:33 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43369 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2GRR1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120718171812.GC21746@redhat.com>
References: <20120718171812.GC21746@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 18 Jul 2012 19:27:08 +0200
Message-ID: <CAPXgP12PioibfQhtAB0fCzL1MXmZvfvQqOGu_ZM0D8Sx4Vq7+w@mail.gmail.com>
Subject: Re: [PATCH] printk: Export struct log size and member offsets through vmcoreinfo
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 7:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:

> Currently I am not exporting log "level" info as that is a bitfield and
> offsetof() bitfields can't be calculated.

We could make the level the lower 3 bits of the byte, export the byte,
and define that only 3 bits of the byte are valid? Would that help?

>  kernel/printk.c |    9 +++++++++
>  1 file changed, 9 insertions(+)

> +       /*
> +        * Export struct log size and field offsets. User space tools can
> +        * parse it and detect any changes to structure down the line.
> +        */
> +       VMCOREINFO_STRUCT_SIZE(log);
> +       VMCOREINFO_OFFSET(log, ts_nsec);
> +       VMCOREINFO_OFFSET(log, len);
> +       VMCOREINFO_OFFSET(log, text_len);
> +       VMCOREINFO_OFFSET(log, dict_len);

Ah, nice, that's how you handle exporting structures, it was still on
my list, to find out how all that should look like.

Cc:ing Greg, to pick it up.

Thanks a lot for taking care of it,
Kay
