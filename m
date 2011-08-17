Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1HQRLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:11:49 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60897 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab1HQRLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:11:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Markus Rechberger <mrechberger@gmail.com>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
Date: Wed, 17 Aug 2011 19:14:52 +0200
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
In-Reply-To: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108171914.52257.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. August 2011, 19:07:01 schrieb Markus Rechberger:
> Hi,
> 
> this patch increases the maximum buffersize for bulk transfers, our
> devices support at least up to 46k bytes for bulk transfers.
> This patch allows us to lower the iterations between kernel and
> userspace and lower the system pressure.

You must not do this. It increases memory pressure too much
by forcing very high order allocations. If your problem is really
the number of syscalls, you must implement scatter/gather.

	Regards
		Ôliver
