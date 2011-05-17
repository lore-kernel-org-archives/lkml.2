Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1EQUxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:53:22 -0400
Received: from mail-yi0-f56.google.com ([209.85.218.56]:33881 "EHLO
	mail-yi0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1EQUxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:53:19 -0400
X-Greylist: delayed 5538 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 May 2011 16:53:19 EDT
MIME-Version: 1.0
Path: b42g2000yqi.googlegroups.com!not-for-mail
Newsgroups: comp.os.linux.embedded
Date: Tue, 17 May 2011 12:21:00 -0700 (PDT)
Complaints-To: groups-abuse@google.com
Injection-Info: b42g2000yqi.googlegroups.com; posting-host=212.76.43.159; posting-account=9fBPtgoAAADEI8zwcnuogZ04nxC8bclF
NNTP-Posting-Host: 212.76.43.159
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux i686; pl-PL; rv:1.9.1.19)
 Gecko/20110430 Iceweasel/3.5.19 (like Firefox/3.5.19),gzip(gfe)
Message-ID: <810e411b-4203-4236-9896-ccfea9edd08c@b42g2000yqi.googlegroups.com>
Subject: Reuse of spi_transfer and spi_message structures for cyclic
 communication with SPI devices?
From: wzab <wzab01@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm writing a device driver for data acquisition system using A/D
converters connected via SPI interface.
To allow flexible ordering of received data, the content
of spi_transfer structures ans spi_message structures
must be set-up in quite sophisticate way before the transfer
may be started.
Refilling of those structures in each sampling cycle will be very
time consuming. I'd prefer to reuse the same structures again and
again, but I can't find any info in the kernel if I'm allowed to.

The documentation suggests to zero spi_transfer ans spi_message
before filling, but doesn't state if they may be used multiple times
with the same I/O buffers without zeroing and refilling.
--
TIA & Regards,
Wojtek Zabolotny
