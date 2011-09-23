Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1IWBEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:04:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49925 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1IWBEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:04:34 -0400
MIME-Version: 1.0
Date: Thu, 22 Sep 2011 18:04:33 -0700
Message-ID: <CAHzg1A-RCpZz-6YzON4cNzrSVpvEP=BCQx0AzZe1negcu2zo6g@mail.gmail.com>
Subject: eMMC low write speed
From: Praveen G K <praveen.gk@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am working on the block driver module of the eMMC driver.  I am
seeing very low write speed for eMMC transfers.  On further debugging,
I observed that every 63rd and 64th transfer takes a long time.  I
have tabulated this by noting the time interval between when CMD 25
(multi block write command) is sent and when DATA_END interrupt is
received.  In normal cases, to transfer 64k (128 blocks of data), it
takes about 2.5ms.  But, under the really slow transfer speed cases,
it takes about 250-350ms to get the data_end interrupt after the multi
block write command is sent.  In some cases, it takes a longer time.
This radically reduces the throughput of the transfers.

I have also enabled the bounce buffers.  As a side question, can
somebody please tell me why the bounce buffer is restricted to 64kB?

Thanks in advance for any help that you can provide me on this issue.
Also, please include my email id in the cc field when replying to this
email since I am not subscribed to this mailing list.

Thanks,
Praveen Krishnan
