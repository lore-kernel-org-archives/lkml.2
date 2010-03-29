Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0C2NbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:31:06 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:53394 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0C2NbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:31:04 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4/5] usb:Push BKL on open down into the drivers
Date: Mon, 29 Mar 2010 15:30:36 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
References: <201001131533.15704.oliver@neukum.org> <alpine.LNX.2.00.1003291159470.24576@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003291159470.24576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003291530.37183.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 29 März 2010 12:04:51 schrieb Jiri Kosina:
> For hiddev, this causes a problem, as you introduced BKL into 
> hiddev_connect() exactly because of the proper dependency -- we have the 
> BKL there to avoid race after usb_register_dev() -- once the device node 
> has been created, open() could happen on it.

Hi,

it seems to me you cannot deadlock with the BKL and an rwsem,
as BKL will be dropped if a task blocks on the rwsem. This is not
a nice feature of the BKL to use. Do you have an alternative idea?

	Regards
		Oliver
