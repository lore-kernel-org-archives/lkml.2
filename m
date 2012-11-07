Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2KHAB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:01:28 -0500
Received: from ozlabs.org ([203.10.76.45]:40453 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab2KHABW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:01:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjur@brendeland.net,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCH resend] virtio_console: Free buffers from out-queue upon close
In-Reply-To: <1352295822-22906-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com> <1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com> <878vayhsca.fsf@rustcorp.com.au> <20121101073951.GA17012@amit.redhat.com> <87r4oc52ov.fsf@rustcorp.com.au> <20121102102047.GE10483@amit.redhat.com> <81C3A93C17462B4BBD7E272753C1057923BE98E5C6@EXDCVYMBSTM005.EQ1STM.local> <1352298171-21869-1-git-send-email-sjur.brandeland@stericsson.com> <1352295822-22906-1-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 08 Nov 2012 10:28:53 +1030
Message-ID: <87sj8l2cea.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:

> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Free pending output buffers from the virtio out-queue when
> host has acknowledged port_close. Also removed WARN_ON()
> in remove_port_data().
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>
> Resending, this time including a proper "Subject"...
> --
>
> Hi Amit,
>
> Note: This patch is compile tested only. I have done the removal
> of buffers from out-queue in handle_control_message()
> when host has acked the close request. This seems less
> racy than doing it in the release function.

This confuses me... why are we doing this in case
VIRTIO_CONSOLE_PORT_OPEN:?

We can't pull unconsumed buffers out of the ring when the other side may
still access it, and this seems to be doing that.

Thanks,
Rusty.
