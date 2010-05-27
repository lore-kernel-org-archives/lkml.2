Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab0E0WlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:41:18 -0400
Received: from forward11.mail.yandex.net ([95.108.130.93]:33951 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab0E0WlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:41:13 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
To: "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 0/3] [RFC] AIO: Fix reference counting in aio_cancel_all() and io_cancel()
Date: Fri, 28 May 2010 02:34:48 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-40-desktop; KDE/4.3.5; x86_64; ; )
Organization: Cifronic ZAO
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280234.48498.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1274999693
X-Yandex-Spam: 1
X-Yandex-Front: smtp12.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix the reference counting in aio_cancel_all() and io_cancel() 
functions which causes unkillable processes stuck in 
wait_for_all_aios() at the io_schedule().

Changelog v1->v2:
   -Split the main patch into one that moves aio_cancel_all() and one that
   adds aio_put_req() calls
-- 
Regards, Sergey Temerkhanov,
Cifronic ZAO
