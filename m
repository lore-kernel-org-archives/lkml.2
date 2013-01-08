Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3AHKtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:49:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3AHKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:49:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: add Packet hub driver for Topcliff Platform controller hub
Date: Tue, 8 Jan 2013 10:49:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: masa-korg@dsn.okisemi.com,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Tomoya MORINAGA <tomoya.rohm@gmail.com>
References: <20130107090210.GA20716@elgon.mountain>
In-Reply-To: <20130107090210.GA20716@elgon.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081049.15118.arnd@arndb.de>
X-Provags-ID: V02:K0:RmPKsTbLChPcJfE9uaAsqXLAZh8TAa8vgeYCItaHW78
 c4LDXiabhcYDTt6pmUXDkcn5W6QYbYCEmUyjaV2BxFD3gytoQp
 SbISQE2KV6pB6FXLwiF/k72A/m8I18BomZ0o8kHYzcBU2HgaJb
 K+MeY6q/Fn3ulaDrGPlJu0VHJH3gEsIcu73/s/+kB+dTmMaBGT
 zYKbeR1DG88MoGTcqydFUjY9IqHKmyeMKkTYzU0YfV1uhPuMpO
 +ZJ68QA9XPfIO4oDT8BJ8KEeYTycLZ2aTI05lHfvFoQIXBnAAk
 rvcdkgsOqoMNr+SFobtxseId0+rg2mbraaMDXhLaOVeNLtSKun
 FsOeWosRiVY9jTc+0N8U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2013, Dan Carpenter wrote:
> Sorry my question is about an old patch.  Smatch complains because we
> only pass a PAGE_SIZE buffer to sysfs files so the test for
> "if (count > PCH_PHUB_OROM_SIZE) {" makes it think we are overflowing.
> In fact, count is never more than 4096 so there is no overflow, but I
> also think that it means only the first 4096 bytes of the firmware gets
> updated.

I think it works correctly as long as user space keeps writing into the
bin file when getting short write return (4096 bytes).

	Arnd
