Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1LSCwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:52:24 -0500
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:39128 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752053Ab1LSCwX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:52:23 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 720172.68442.bm@omp1012.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=CZMICLChYZ8lsqzXeBED7gAAqNJ1zot7OfXG7raSXgole4NkOrsSyKtEUCBELFKZuxdop247yRF7/TyOFnBH8lXi78EDE1Mhg1+NOZsCFl/IHWwpMDZr4XvO2bff2+JQgSzIV2DWxn3UKy+FDE4Ht4ZaPqsjnykRQSbg2njn/rA=;
X-YMail-OSG: ryaBm0YVM1la_xCZL6.G.VEcK58oXP1qlmF85Vhd41t_c3O
 9d9wt0S6IiVqFhZP3JJAfkrY9am0h2wF2CaeByqFpTHRV2WY3uK7XUB0Tvwd
 omaqpUalzQbhO7aIA506M5giGtJ9zlIsiRkyBXlFksmtc6Eenc5hToeNonIN
 i5npXTnC.OY17F.j8urmcJxj0LGsKXnp6RjpslNatP6mkwnchvzJc6kdOf8L
 kdtyiOmsXtGoyfAByeC_Sfs3YvXeePuu_9OeNXvPaEhEzlqMaLQXAoh7ty9A
 BFqny0.h1KNJJTyT1sth_WMi3NnACI3HPt7hXHC0dGDBZFGAjWBcEGIZ5jVa
 r9JGbT7r641gY5RTHYAMlZ460fK3HOzbLzG2_z.zzKbHXYUC7E9.9pKLjF4v
 oK5jRzbK34HxTYwuf3xcpZoRFaN7jksk.VRCR2lrqHemI9NyuJw79_s4-
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.115.331698
Message-ID: <1324263142.5056.YahooMailClassic@web113204.mail.gq1.yahoo.com>
Date: Sun, 18 Dec 2011 18:52:22 -0800 (PST)
From: John <jhnlmn@yahoo.com>
Subject: How to keep OS running after hard drive removal?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am working on an embedded Linux device with a USB hard drive. There is a swap file on this drive.  The hard drive may be powered down at any moment before being powered back on few seconds later. This leads to various error messages, such as:
"Write-error on swap-device"
"Kernel panic - not syncing: Attempted to kill init!"
or exceptions in various applications, which is understandable since some page in/out requests failed.
My goal is to somehow prevent this from happening and recover the system without rebooting the OS.
I can postpone the crash by calling scsi_block_requests, but I cannot keep them blocked forever.
I tried to kill some user mode tasks (using send_sig_info) in response to USB_DEVICE_REMOVE notification, but still keep getting exceptions.
I am also thinking whether it is possible to prevent SCSI device from being destroyed when USB device is removed,  but keep it around and then somehow reconnect it to the new USB device, which will be created few seconds later when USB device is powered again. Since this is the same disk, then, may be, I can resume all pending requests without re-mounting the disk.
What is your opinion? Can something like that be done? Or is it impossible to cleanly recover OS after hard drive removal?

Thank you
John


