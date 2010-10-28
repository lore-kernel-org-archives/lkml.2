Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032Ab0J1RiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:38:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42540 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab0J1RiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=W2zSTFCd5cHji8bRt7DCqbcB4TSauw2s2Wx/fKaoMZvbVl40F/5Bol+TGqvg7pR5SE
         HTa+MgdpFgKIfjKftnEvG7TTpGX1K8338cQpC6rqRMpmbvNqF0OqcMEAsAvSA03Wb4wG
         KG/2B9gYYf0auiDc0mJWGleKSdbx6LANOGdmY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=zj-7MfUihKLvsrP0QJng1mQyDcUmyQWxVY2jR@mail.gmail.com>
References: <AANLkTi=zj-7MfUihKLvsrP0QJng1mQyDcUmyQWxVY2jR@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Oct 2010 10:37:45 -0700
Message-ID: <AANLkTin9k=nM8N5FB7gnpXfRhU2axYKZx=rELEppqY_a@mail.gmail.com>
Subject: Re: v2.6.36-rc8..v2.6.36 regression on NULL pointer deference at disk_replace_part_tbl+0x32
To: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:25 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I've filled out a bug report for a regression when I enable USB tether
> on my Nexus One when hooked up to my laptop. I get a NULL pointer
> dereference. This is a regression between v2.6.36-rc8 and v2.6.36. I
> will bisect when I get a chance.

<etc>

> https://bugzilla.kernel.org/show_bug.cgi?id=21372

<etc>

> BUG: unable to handle kernel NULL pointer dereference at 00000000000003a0

> Pid: 22, comm: khubd Not tainted 2.6.36-wl+ #13 6460DWU/6460DWU
> RIP: 0010:[<ffffffff812aec32>]  [<ffffffff812aec32>] disk_replace_part_tbl+0x32/0x80

<etc>

> Call Trace:
>
>  [<ffffffff812aed08>] disk_release+0x28/0x50
>  [<ffffffff813833f7>] device_release+0x27/0xa0
>  [<ffffffff812bcd87>] kobject_release+0x47/0x90
>  [<ffffffff812bcd40>] ? kobject_release+0x0/0x90
>  [<ffffffff812be1e7>] kref_put+0x37/0x70
>  [<ffffffff812bcc47>] kobject_put+0x27/0x60
>  [<ffffffff812bcd40>] ? kobject_release+0x0/0x90
>  [<ffffffff812aed47>] put_disk+0x17/0x20
>  [<ffffffff813c3c37>] sg_device_destroy+0x67/0xa0
>  [<ffffffff813c3bd0>] ? sg_device_destroy+0x0/0xa0
>  [<ffffffff812be1e7>] kref_put+0x37/0x70
>  [<ffffffff813c3b9e>] sg_remove+0xfe/0x130
>  [<ffffffff81383d51>] device_del+0xc1/0x1d0
>  [<ffffffff81383e76>] device_unregister+0x16/0x30
>  [<ffffffff813b6e95>] __scsi_remove_device+0xa5/0xc0
>  [<ffffffff813b322c>] scsi_forget_host+0x5c/0x80
>  [<ffffffff813aab1f>] scsi_remove_host+0x6f/0x120
>  [<ffffffffa004c46b>] quiesce_and_remove_host+0x6b/0xc0 [usb_storage]
>  [<ffffffffa004c592>] usb_stor_disconnect+0x22/0x40 [usb_storage]

Odd, I get 0 results with a:

git log v2.6.36-rc8..v2.6.36 scsiglue.c protocol.c transport.c usb.c
initializers.c sierra_ms.c option_ms.c

So the issue must be elsewhere unless there was a subsystem change
that triggered a new issue on usb-storage.

  Luis
