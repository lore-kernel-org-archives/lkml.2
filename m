Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab1DLChv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:37:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54827 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153Ab1DLChv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 22:37:51 -0400
Message-Id: <1302575869.13492.1440076201@webmail.messagingengine.com>
X-Sasl-Enc: C3zISBPQnLGDZxmllZMFD36qRXOgplFWCGBxCcMJSRME 1302575869
From: "Adam McLaurin" <lkml@irotas.net>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Loopback and Nagle's algorithm
Date: Mon, 11 Apr 2011 22:37:49 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understand that disabling Nagle's algorithm via TCP_NODELAY will
generally degrade throughput. However, in my scenario (150 byte
messages, sending as fast as possible), the actual throughput penalty
over the network is marginal (maybe 10% at most).

However, when I disable Nagle's algorithm when connecting over loopback,
the performance hit is *huge* - 10x reduction in throughput.

The question is, why is disabling Nagle's algorithm on loopback so much
worse w.r.t. throughput? Is there anything I can do to reduce the
incurred throughput penalty?

Thanks,
Adam
