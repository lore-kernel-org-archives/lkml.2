Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0DZK5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:57:52 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:37504 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab0DZK5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aDB3BQjcOKGQeq0n23GKIbAkkG3cizNV/qO+RBtgFOYcgz/A6WqSmmChcCMO+8/Q3v
         9kVVWUiMZUN3TeUnoFxsz7MKatDXbyOdxzhKtN6yeLmSfSb05KCXfKUoscoGz/3OKNVS
         iFMKbUof+tsR4Crlv9+BBunt0mZL1I7tvtOsA=
MIME-Version: 1.0
Date: Mon, 26 Apr 2010 16:27:46 +0530
Message-ID: <i2kf74c922b1004260357x6548f7ddz6e0a38fafa4f54ce@mail.gmail.com>
Subject: zero copy in usbip send and recieve path
From: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       usbip-devel@lists.sourceforge.net,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'am trying to implement zero copy in USBIP while sending / receiving
usbip packets.

I started it with send path. The device which I used is mass storage.
I'am using linux kernel 2.6.15.

After virtualization, once the file copy starts from device to pc each
usbip packet carries payload of 64K.

I'am allocating this 64K buffer through __get_free_pages() (with order
4) and assigning
the buffer pointer to urb. After completion of URB i'am trying to send
this buffer page by page
by using tcp_sendpage instead of calling kernel_sendmsg(), this is to
avoid copy which is
done in the TCP send path.

By doing this way it is able to send the buffer successfully, but I'am
not finding the way to free
this buffer. This copy continues until the entire memory is consumed.

who will free this buffer?

1) If i call free_pages for entire 64K right after tcp_sendpage (i.e
after sending all the pages, 64K). then observed
the Kernel panic. It is obvious that the tcp core is not yet finished its job.

2) TCP core is also not freeing these pages.

This might be because, I allocated 64K buffer at once and trying to
free it page by page.

I need some help to resolve this issue.

Performance wise there is a huge jump in throughput.

Thanks,
Vinai
